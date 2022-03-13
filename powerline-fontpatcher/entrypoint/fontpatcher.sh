#!/bin/sh

export WORKING_DIR=/working
export WORKING_SCRIPT="/usr/bin/python2 /root/fontpatcher/scripts/powerline-fontpatcher"

for ARG in "$@"; do
  case ${ARG} in
    -n)
      WORKING_SCRIPT="${WORKING_SCRIPT} --no-rename"
      break
      ;;
    *)
      ;;
  esac
done

for ARG in "$@"; do
  case ${ARG} in
    -n)
      ;;
    *)
      if [[ "${ARG}" =~ .+/.+ ]]; then
        FILE_LIST=
        if [[ "${ARG}" =~ ^/.* ]]; then
          FILE_LIST=${ARG}
        else
          FILE_LIST="${WORKING_DIR}/${ARG}"
        fi

        for f in $(ls -1 ${FILE_LIST} 2>/dev/null); do
          echo "Processing ${f}..."
          cd $(/usr/bin/dirname "${f}")
          if ! ${WORKING_SCRIPT} "${f}" 2>/tmp/PatchError.log; then
            echo
            cat /tmp/PatchError.log
            echo
          fi
          cd "${WORKING_DIR}"
        done
      else
        FIND_CMD=
        while read -r line; do
          if [ -n "${FIND_CMD}" ]; then
            FIND_CMD="${FIND_CMD} -o -name '${line}'"
          else
            FIND_CMD="/usr/bin/find ${WORKING_DIR} -name '${line}'"
            fi
        done <<< $(echo "${ARG}" | tr " " "\n")

        while read -r line; do
          if [ -n "${line}" ]; then
            echo Processing "${line}"...
            cd $(/usr/bin/dirname "${line}")
            if ! ${WORKING_SCRIPT} "${line}" 2>/tmp/PatchError.log; then
              echo
              cat /tmp/PatchError.log
              echo
              fi
            cd ${WORKING_DIR}
          fi
        done <<< $(eval "${FIND_CMD}")
      fi
      ;;
  esac
done

