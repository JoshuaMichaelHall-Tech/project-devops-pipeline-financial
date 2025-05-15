#\!/bin/bash
# Setup script for the DevOps Pipeline project

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check for required tools
check_requirements() {
  echo -e "${YELLOW}Checking requirements...${NC}"
  
  local missing_tools=0
  
  if \! command -v aws &> /dev/null; then
    echo -e "${RED}AWS CLI not found. Please install it: https://aws.amazon.com/cli/${NC}"
    missing_tools=1
  fi
  
  if \! command -v docker &> /dev/null; then
    echo -e "${RED}Docker not found. Please install it: https://docs.docker.com/get-docker/${NC}"
    missing_tools=1
  fi
  
  if \! command -v git &> /dev/null; then
    echo -e "${RED}Git not found. Please install it: https://git-scm.com/downloads${NC}"
    missing_tools=1
  fi
  
  if \! command -v python3 &> /dev/null; then
    echo -e "${RED}Python3 not found. Please install it: https://www.python.org/downloads/${NC}"
    missing_tools=1
  fi
  
  if [ $missing_tools -ne 0 ]; then
    echo -e "${RED}Please install the missing tools and run the script again.${NC}"
    exit 1
  fi
  
  echo -e "${GREEN}All requirements satisfied\!${NC}"
}

# Set up local development environment
setup_local_environment() {
  echo -e "${YELLOW}Setting up local development environment...${NC}"
  
  # Create Python virtual environment
  python3 -m venv .venv
  source .venv/bin/activate
  pip install -r src/app/requirements.txt
  
  # Create local config
  if [ \! -f config/local.env ]; then
    cp config/local.env.example config/local.env
    echo -e "${YELLOW}Created local.env from example. Please update it with your values.${NC}"
  fi
  
  echo -e "${GREEN}Local development environment setup complete\!${NC}"
}

# Set up CI/CD pipeline locally
setup_cicd_local() {
  echo -e "${YELLOW}Setting up local CI/CD pipeline...${NC}"
  
  # Create GitHub actions local runner directory
  mkdir -p .github/workflows/local
  
  # Build local Docker image for testing
  docker build -t devops-pipeline-financial-local -f config/Dockerfile.local .
  
  echo -e "${GREEN}Local CI/CD pipeline setup complete\!${NC}"
  echo -e "${YELLOW}To run the pipeline locally:${NC}"
  echo -e "  docker run -it --rm devops-pipeline-financial-local"
}

# Main function
main() {
  echo -e "${GREEN}Setting up DevOps Pipeline project...${NC}"
  
  check_requirements
  setup_local_environment
  setup_cicd_local
  
  echo -e "${GREEN}Setup complete\! Next steps:${NC}"
  echo -e "1. Update config/local.env with your values"
  echo -e "2. Run the local pipeline with: docker run -it --rm devops-pipeline-financial-local"
  echo -e "3. Explore the sample workflows in .github/workflows"
}

# Run the main function
main
EOF < /dev/null