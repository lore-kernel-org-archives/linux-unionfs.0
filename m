Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FmRO9Yo1"
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C072135;
	Mon,  4 Dec 2023 06:30:57 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id 6a1803df08f44-67a8a745c43so33137346d6.0;
        Mon, 04 Dec 2023 06:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701700256; x=1702305056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SSCVDR3Hr7VCdexC+W7l8WVvF7+UqIZgiNSIhQuzgY8=;
        b=FmRO9Yo161Qd1vZ4Yz7kISy8xiuSryRboZco+knLoxPrqnFBmbSwqNV+7I3ke39PT4
         TV+WQjQGQfrSChXNG8pB3Ptk8SsOZIStaahJL7BuxmPKxeoyY4zeCZYswK61tlFqKWCK
         xyoJOvSP84tHgJ/6o9mzc21eeI+RwAahUhVoVjvqV38xPdxDtcEbBGggo8fZDmwc6pWY
         uuBiF/IpW0iIxsdH+c6sWtSD0Z6w5sde2TyUmTvPhtjOEX6/ypVqdAsuQG21zRG+l12P
         TrnxM2tPOgyxhGx2VNoyqWjqpFjgUQFeKqZTjPiieN7JqI+AAp7ox0xVmednplOd6zLd
         3Zcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701700256; x=1702305056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SSCVDR3Hr7VCdexC+W7l8WVvF7+UqIZgiNSIhQuzgY8=;
        b=b8qMmYmWR76HeU8yNXltNak3Y2gzKM08XBU9vN1pY/f68munw/rtvWrbi1H+M99ovL
         0aZktVKKRDnz4obxZcztZmOSpBRuJEUNw19JT1mwPP/gTBwdqiPzGrUhkbkBfhB266d4
         r1OTKGMz8pkycsBWuC9isewzVJphjjzFeWNeM3BGLee0Z2zHccswMoooCS2mzYKtoLXc
         eMDuP9PUn96/xdBu6zINzN2nXatZUkVv4nw6VHG1GNcuSE2n04uQlMwJAoWgtAv3US5j
         GFlx6E7SlaT0ivbGZXOFaIyPdmVkHurmmRpzY/YTmGS4wlIOM6ChuM8yKTwaivBJJohz
         PHHA==
X-Gm-Message-State: AOJu0YymkUS8ufv6EfAQ6Rz0E2ODcHBswdcsv3gMs0nFlrol8+K0J/HY
	Pu3U1KQtc8NGkvsS+afIJko1PlcaGKO6HER6mZM=
X-Google-Smtp-Source: AGHT+IEkVGECTYy/WltC809GR7OcD7CVGMASkvfNUz/1s96Lou9hy5N0wL4PDD3faywDUK56zGwr++x9iqvSreG9o18=
X-Received: by 2002:a0c:cc85:0:b0:67a:1d4d:2c0c with SMTP id
 f5-20020a0ccc85000000b0067a1d4d2c0cmr4475227qvl.24.1701700256335; Mon, 04 Dec
 2023 06:30:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231122152013.2569153-1-amir73il@gmail.com>
In-Reply-To: <20231122152013.2569153-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 4 Dec 2023 16:30:45 +0200
Message-ID: <CAOQ4uxiBbL4iV6f6MLXeVq-V+uNaocTD5F=8ZJy9Bxvqr-Hjwg@mail.gmail.com>
Subject: Re: [PATCH v2] overlay/026: Fix test expectation for newer kernels
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 22, 2023 at 5:20=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> From: Alexander Larsson <alexl@redhat.com>
>
> The test checks the expectaion from old kernels that set/get of
> trusted.overlay.* xattrs is not supported on an overlayfs filesystem.
>
> New kernels support set/get xattr of trusted.overlay.* xattrs, so adapt
> the test to check that either both set and get work on new kernel, or
> neither work on old kernel.
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Zorro,
>
> Per your request on v1 [1], I've added a helper to check escaped overlay
> xattrs support.
>
> The helper was taken from the patch that adds test overlay/084 [2], and
> re-factored, but other than that, overlay/084 itself is unchanged, so
> I am not re-posting it nor any of the other patches in the overlay tests
> for v6.7-rc1.
>
> Let me know if this works for you.

Ping.

>
> Thanks,
> Amir.
>
> [1] https://lore.kernel.org/fstests/20231116075250.ntopaswush4sn2qf@dell-=
per750-06-vm-08.rhts.eng.pek2.redhat.com/
> [2] https://lore.kernel.org/fstests/20231114064857.1666718-2-amir73il@gma=
il.com/
>
>  common/overlay        | 19 +++++++++++++++++++
>  tests/overlay/026     | 42 +++++++++++++++++++++++++++++-------------
>  tests/overlay/026.out |  2 --
>  3 files changed, 48 insertions(+), 15 deletions(-)
>
> diff --git a/common/overlay b/common/overlay
> index 7004187f..8f275228 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -201,6 +201,25 @@ _require_scratch_overlay_features()
>         _scratch_unmount
>  }
>
> +_check_scratch_overlay_xattr_escapes()
> +{
> +       local testfile=3D$1
> +
> +       touch $testfile
> +       ! ($GETFATTR_PROG -n trusted.overlay.foo $testfile 2>&1 | grep -E=
 -q "not (permitted|supported)")
> +}
> +
> +_require_scratch_overlay_xattr_escapes()
> +{
> +       _scratch_mkfs > /dev/null 2>&1
> +       _scratch_mount
> +
> +        _check_scratch_overlay_xattr_escapes $SCRATCH_MNT/file || \
> +                  _notrun "xattr escaping is not supported by overlay"
> +
> +       _scratch_unmount
> +}
> +
>  _require_scratch_overlay_verity()
>  {
>         local lowerdirs=3D"$OVL_BASE_SCRATCH_MNT/$OVL_UPPER:$OVL_BASE_SCR=
ATCH_MNT/$OVL_LOWER"
> diff --git a/tests/overlay/026 b/tests/overlay/026
> index 77030d20..25c70bc8 100755
> --- a/tests/overlay/026
> +++ b/tests/overlay/026
> @@ -52,26 +52,42 @@ touch $SCRATCH_MNT/testf1
>  # getfattr    ok         no attr     ok    ok
>  #
>  $SETFATTR_PROG -n "trusted.overlayfsrz" -v "n" \
> -  $SCRATCH_MNT/testf0 2>&1 | _filter_scratch
> +  $SCRATCH_MNT/testf0 2>&1 | tee -a $seqres.full | _filter_scratch
>
>  _getfattr --absolute-names -n "trusted.overlayfsrz" \
> -  $SCRATCH_MNT/testf0 2>&1 | _filter_scratch
> +  $SCRATCH_MNT/testf0 2>&1 | tee -a $seqres.full | _filter_scratch
>
> -# {s,g}etfattr of "trusted.overlay.xxx" should fail.
> +# {s,g}etfattr of "trusted.overlay.xxx" fail on older kernels
>  # The errno returned varies among kernel versions,
> -#            v4.3/7   v4.8-rc1    v4.8       v4.10
> -# setfattr  not perm  not perm   not perm   not supp
> -# getfattr  no attr   no attr    not perm   not supp
> +#            v4.3/7   v4.8-rc1    v4.8       v4.10     v6.7
> +# setfattr  not perm  not perm   not perm   not supp  ok
> +# getfattr  no attr   no attr    not perm   not supp  ok
>  #
> -# Consider "Operation not {supported,permitted}" pass.
> +# Consider "Operation not {supported,permitted}" pass for old kernels.
>  #
> -$SETFATTR_PROG -n "trusted.overlay.fsz" -v "n" \
> -  $SCRATCH_MNT/testf1 2>&1 | _filter_scratch | \
> -  sed -e 's/permitted/supported/g'
> +if _check_scratch_overlay_xattr_escapes $SCRATCH_MNT/testf0; then
> +       setexp=3D""
> +       getexp=3D"No such attribute"
> +else
> +       setexp=3D"Operation not supported"
> +       getexp=3D"Operation not supported"
> +fi
>
> -_getfattr --absolute-names -n "trusted.overlay.fsz" \
> -  $SCRATCH_MNT/testf1 2>&1 | _filter_scratch | \
> -  sed -e 's/permitted/supported/g'
> +getres=3D$(_getfattr --absolute-names -n "trusted.overlay.fsz" \
> +  $SCRATCH_MNT/testf1 2>&1 | tee -a $seqres.full | _filter_scratch | \
> +  sed 's/permitted/supported/')
> +
> +[[ "$getres" =3D~ "$getexp" ]] || echo unexpected getattr result: $getre=
s
> +
> +setres=3D$($SETFATTR_PROG -n "trusted.overlay.fsz" -v "n" \
> +  $SCRATCH_MNT/testf1 2>&1 | tee -a $seqres.full |_filter_scratch | \
> +  sed -e 's/permitted/supported/g')
> +
> +if [ "$setexp" ]; then
> +       [[ "$setres" =3D~ "$expres" ]] || echo unexpected setattr result:=
 $setres
> +else
> +       [[ "$setres" =3D=3D "" ]] || echo unexpected setattr result: $set=
res
> +fi
>
>  # success, all done
>  status=3D0
> diff --git a/tests/overlay/026.out b/tests/overlay/026.out
> index c4572d67..53030009 100644
> --- a/tests/overlay/026.out
> +++ b/tests/overlay/026.out
> @@ -2,5 +2,3 @@ QA output created by 026
>  # file: SCRATCH_MNT/testf0
>  trusted.overlayfsrz=3D"n"
>
> -setfattr: SCRATCH_MNT/testf1: Operation not supported
> -SCRATCH_MNT/testf1: trusted.overlay.fsz: Operation not supported
> --
> 2.34.1
>
