package: clean
	mkdir pragger-$(VERSION)
	cd pragger-$(VERSION);\
	 mkdir bin data data/pragger;\
	 cp ../../pragger.rb bin/pragger;\
	 cp ../setup.rb .;\
	 cp ../bin-pre-setup.rb bin/pre-setup.rb
	cd ../; svn export plugin setup/pragger-$(VERSION)/data/pragger/plugin

archive: package
	tar -cvz pragger-$(VERSION)/ > pragger-$(VERSION).tgz

clean:
	rm -rf pragger-*
