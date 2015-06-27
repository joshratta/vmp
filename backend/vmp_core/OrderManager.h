#ifndef VMP_CORE_ORDER_MANAGER_H_
#define VMP_CORE_ORDER_MANAGER_H_

#include "../common/stdafx.h"
#include "Source.h"
#include "VisualWorker.h"
#include <string.h>

class OrderManager {
public:
	OrderManager() {
		memset(layers, 0, 4096);
		l = (char*)layers;
	}

	char layers[4096];
	char lr[4096];
	vector<VisualWorker*> m;
	char *l;

	void reset(vector<VisualWorker*> w) {
		memcpy(lr, layers, 4096);
		l = (char*)lr;
		m.clear();
		m.resize(w.size());
		std::copy(w.begin(), w.end(), m.begin());
		m = w;
	}

	bool hasNext() {
		return (m.size() > 0);
	}

	VisualWorker* getNext() {
		if (0 == m.size()) {
			return NULL;
		}
		VisualWorker* result = NULL;
		vector <VisualWorker*>::iterator It;
		do {
			char *next = strsep(&l, ";");
			if (!next) break;
			// look for this item here, if we find it, return it and delete
			for (It = m.begin(); It != m.end(); ++It) {
				VisualWorker*r = *It;
				Source *src = r->GetSource();
				if (!strcmp(src->id, next)) {
					result = *It;
					m.erase(It);
					return result;
				}
			}
		} while (true);
		if (m.size() == 0)
			return NULL;
		result = (m.back());
		m.pop_back();
		return result;
	}

	void registerLayers(char *s) {
		memset(layers, 0, 4096);
		strcpy_s(layers, 4096, s);
	}

};

#endif