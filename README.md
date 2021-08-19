# datacube-docker

General purpose Docker Images related to the Open Data Cube project

## How this works

Each folder has a Dockerfile and a version.txt, as a minimum. There are two GitHub Actions
pipelines per image, one to test and one to build. In order to rebuild an image and have
it pushed to GitHub, you should increment the number in the version.txt file. Changing _anything_
in the folder of an Image currently triggers a run too.

Each project should have a docker-compose file that can be used to run and test the image.

## List of images

* [opendatacube/datacube-statistician](statistician/readme.md): A minimal Image that is used to run Statistician processing
* [opendatacube/datacube-index](index/readme.md): A suite of tools to manage indexing into an Open Data Cube database

## How to update requirements

* Empty out the `constraints.txt` file (delete all the contents, but leave it there)
* Run `docker build . --progress=plain`
* Check that the build succeeds, and copy out the output of the `pip freeze` command, which each image should be doing
* Paste the output of `pip freeze` into the `constraints.txt` and check that it makes sense and isn't too different from before
* Commit the changes and push to GitHub for the automated build, and confirm it works there too.
