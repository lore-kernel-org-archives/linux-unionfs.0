Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fj3BKxgn"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CA4D5
	for <linux-unionfs@vger.kernel.org>; Mon,  4 Dec 2023 08:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701709103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fIzTlQv5KnrW8DVcrmaZ1IE85qYgQLvl4OiJVWobUsI=;
	b=Fj3BKxgnnnK3I5GQW2pDPdko8QSAZVUhhAOsEbuX6ZlR9VyJIZ/qsfvOjnddPNp1XvVuB/
	CIO3Tc56Ma/qxlA694po+L8gOZD0cLkxZ/GO8SzFdK5ZNgRmP6ziJ6IUbzN6gg2FVlmI67
	CYzOR/xbNxEhqyycI310UiaA6e0QN+A=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-I-UzbOYKMC-BYGWfJIBtqQ-1; Mon, 04 Dec 2023 11:58:22 -0500
X-MC-Unique: I-UzbOYKMC-BYGWfJIBtqQ-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1d092b42fb4so9641065ad.0
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Dec 2023 08:58:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701709101; x=1702313901;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fIzTlQv5KnrW8DVcrmaZ1IE85qYgQLvl4OiJVWobUsI=;
        b=wClLLuakNNxNCJJFeIpPS9MpQZB6GtSqrRhbqBVUUchOrqDMNSTw9oaAPaS/yBwd5v
         KA5FS+83Mm4Q+ktoVVYUBR9Tcw6RUJMPhVbMRikuHuAMyBCpZyBKrCGUoTLYrawsiRSZ
         c0Uyn/lSs/bkYSub7dAuVorJ8hD0tlDy78F1TUptjIgZDJqszflk9VjUrAFrMzx0KSaT
         GgTAeGwV8GHfUv9ZFKmgmGw/W2sfA8EatIASjQNHoMSoMZsx8GCrMCWwWxT/+7/3jzww
         xMh9Fv4BniUJVz8Uq8YZYEOP7tBhFqPpVFM4sz06f3wuq5v0kxHiiZG/FBMgjApNi83e
         zeDA==
X-Gm-Message-State: AOJu0YxONPybVqBOZKtd3Nr5hknYtocEEiUGBrvmDrEHECFiIK9xeWAE
	tSm/N+qJeRtfx4MlXCV5SuzyZ0KVdXGGZP5axdM4zP8zdkB5xlBV318BrmZ3oZoz8t5AQ8YFnZS
	VP1/Gq+tTogXyLKy9kjMuWR0FvA==
X-Received: by 2002:a17:902:d4cc:b0:1d0:9c9d:dcdf with SMTP id o12-20020a170902d4cc00b001d09c9ddcdfmr15768plg.39.1701709101413;
        Mon, 04 Dec 2023 08:58:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHe0BU4wn9A1I0zDXOYv15HHdRxejmNdMVasfytwMeFnL+SHg6cnuHkZ2h7dqLSJYODovDbBA==
X-Received: by 2002:a17:902:d4cc:b0:1d0:9c9d:dcdf with SMTP id o12-20020a170902d4cc00b001d09c9ddcdfmr15758plg.39.1701709100993;
        Mon, 04 Dec 2023 08:58:20 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o12-20020a170902778c00b001cf511aa772sm8638364pll.145.2023.12.04.08.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 08:58:20 -0800 (PST)
Date: Tue, 5 Dec 2023 00:58:17 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v2] overlay/026: Fix test expectation for newer kernels
Message-ID: <20231204165817.6bz2vf2rogo7a6mo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231122152013.2569153-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231122152013.2569153-1-amir73il@gmail.com>

On Wed, Nov 22, 2023 at 05:20:13PM +0200, Amir Goldstein wrote:
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




> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/fstests/20231116075250.ntopaswush4sn2qf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
> [2] https://lore.kernel.org/fstests/20231114064857.1666718-2-amir73il@gmail.com/
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
>  	_scratch_unmount
>  }
>  
> +_check_scratch_overlay_xattr_escapes()
> +{
> +	local testfile=$1
> +
> +	touch $testfile
> +	! ($GETFATTR_PROG -n trusted.overlay.foo $testfile 2>&1 | grep -E -q "not (permitted|supported)")
> +}
> +
> +_require_scratch_overlay_xattr_escapes()
> +{
> +	_scratch_mkfs > /dev/null 2>&1
> +	_scratch_mount
> +
> +        _check_scratch_overlay_xattr_escapes $SCRATCH_MNT/file || \
> +                  _notrun "xattr escaping is not supported by overlay"
> +
> +	_scratch_unmount
> +}
> +

Hi Amir,

Sorry for this late review, got a little busy on other things recently.
Won't this patch be conflict with another patchset which you/Alex have sent:
  https://lore.kernel.org/fstests/20231114064857.1666718-2-amir73il@gmail.com/

So you'll rebase that patchset on this, right?

Thanks,
Zorro



>  _require_scratch_overlay_verity()
>  {
>  	local lowerdirs="$OVL_BASE_SCRATCH_MNT/$OVL_UPPER:$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
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
> +	setexp=""
> +	getexp="No such attribute"
> +else
> +	setexp="Operation not supported"
> +	getexp="Operation not supported"
> +fi
>  
> -_getfattr --absolute-names -n "trusted.overlay.fsz" \
> -  $SCRATCH_MNT/testf1 2>&1 | _filter_scratch | \
> -  sed -e 's/permitted/supported/g'
> +getres=$(_getfattr --absolute-names -n "trusted.overlay.fsz" \
> +  $SCRATCH_MNT/testf1 2>&1 | tee -a $seqres.full | _filter_scratch | \
> +  sed 's/permitted/supported/')
> +
> +[[ "$getres" =~ "$getexp" ]] || echo unexpected getattr result: $getres
> +
> +setres=$($SETFATTR_PROG -n "trusted.overlay.fsz" -v "n" \
> +  $SCRATCH_MNT/testf1 2>&1 | tee -a $seqres.full |_filter_scratch | \
> +  sed -e 's/permitted/supported/g')
> +
> +if [ "$setexp" ]; then
> +	[[ "$setres" =~ "$expres" ]] || echo unexpected setattr result: $setres
> +else
> +	[[ "$setres" == "" ]] || echo unexpected setattr result: $setres
> +fi
>  
>  # success, all done
>  status=0
> diff --git a/tests/overlay/026.out b/tests/overlay/026.out
> index c4572d67..53030009 100644
> --- a/tests/overlay/026.out
> +++ b/tests/overlay/026.out
> @@ -2,5 +2,3 @@ QA output created by 026
>  # file: SCRATCH_MNT/testf0
>  trusted.overlayfsrz="n"
>  
> -setfattr: SCRATCH_MNT/testf1: Operation not supported
> -SCRATCH_MNT/testf1: trusted.overlay.fsz: Operation not supported
> -- 
> 2.34.1
> 

