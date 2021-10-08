// Copyright 2019 Drone.IO Inc. All rights reserved.
// Use of this source code is governed by the Drone Non-Commercial License
// that can be found in the LICENSE file.

// +build !oss

package card

import (
	"io"
	"net/http"
	"strconv"

	"github.com/drone/drone/core"
	"github.com/drone/drone/handler/api/render"

	"github.com/go-chi/chi"
)

func HandleFindDataById(
	cardStore core.CardStore,
	repoStore core.RepositoryStore,
) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var (
			namespace = chi.URLParam(r, "owner")
			name      = chi.URLParam(r, "name")
		)
		_, err := repoStore.FindName(r.Context(), namespace, name)
		if err != nil {
			render.NotFound(w, err)
			return
		}

		cardId, err := strconv.ParseInt(chi.URLParam(r, "id"), 10, 64)
		if err != nil {
			render.BadRequest(w, err)
			return
		}

		card, err := cardStore.FindById(r.Context(), cardId)
		if err != nil {
			render.NotFound(w, err)
			return
		}
		cardData, err := cardStore.FindData(r.Context(), card.Id)
		if err != nil {
			render.NotFound(w, err)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		io.Copy(w, cardData)
		cardData.Close()
	}
}
