THIS = $(shell pwd)
EXCLUDE = .htaccess-example .htaccess elm.js index.html
excludes := $(foreach config,$(EXCLUDE),--exclude=$(config))

.PHONY : help clean deploy drydeploy

help:
	@echo
	@echo "Usage examples:"
	@echo
	@echo
	@echo "make drydeploy|deploy TARGET=[user]@[ip|host]:[path]"
	@echo
	@echo "make drydeploy TARGET=user@000.000.000.000:/var/www/sitename/"
	@echo "make deploy TARGET=user@000.000.000.000:/var/www/sitename/"
	@echo
	@echo
	@echo "make drydeploy TARGET=shugo:/var/www/vhosts/sassehugo.com/"
	@echo

deploy:
ifdef TARGET
	@echo
	@npm run prod
	@rsync -rltvzpO --checksum --delete $(excludes) ${THIS}/public/ ${TARGET}
	@echo
else
	@echo
	@echo "You must define TARGET"
	@echo
endif

drydeploy:
ifdef TARGET
	@echo
	@npm run prod
	@rsync -rltvzpO --checksum --delete --dry-run $(excludes) ${THIS}/public/ ${TARGET}
	@echo
else
	@echo
	@echo "You must define TARGET"
	@echo
endif
