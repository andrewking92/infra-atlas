provider "mongodbatlas" {

}


module "atlas-cluster" {
  source = "./modules/cluster"
}