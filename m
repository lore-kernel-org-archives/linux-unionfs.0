Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A591E519
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Jun 2025 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749144252; cv=none; b=Lz53svfVnlWBAXiZ3f0bLCMMaiV8eTbNUqyRbTSixklQavXnf73ApoaalLDNbXrIAhjcrzcsQ01z50VoVw4bohIWtTk+Opg+b5MJ1dIfGy9KXYpE35Og9OJ2kYRL3nyK3C70+JX4oyNe2VJ/UPNzJms8bz9QBYtEj943rYLx1Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749144252; c=relaxed/simple;
	bh=RyvXdEJbqyUl9kAT21DMLDdXQJ5KeRBFWaOc/9QQQBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DUR/qJ+U4yoADAh/oaggTri+uSThiFLH7fPiB8hSFQGZLFDgqXn51LK3YZ5tJblSwEUmpjgA+BBN2PHMpbGwExOtuW6Q3Yl+2ceP938YMDHkZPkjR6PyDKn1LChTy6oIIUa/88ZQ0Zfsm78DNng/F2EkZbbe9D+Jdm3eGxuei4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O0AOYoLi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O0AOYoLi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749144250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NilGyannDkSG1qdzHF1/Z/9qZ2bbYcqHW2ABfSOqUNg=;
	b=O0AOYoLiSTAfpPVb+bPMvTSdEpIlZj/v7vjwHLCtL2Vtnnuhc6a9+xqhf2JqGAQRvoFqCO
	au+VPlIcD9x/UmvxWePHg4f6zNf34rWuhhVOxas+PTjXzk6oaKNICWFGuXKwq0Hu9Ljjv/
	SJouUF899I1DjFbqIZ2whYgsEjCyGI0=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-NDUfdS8uODC0KhQ9uSCnMA-1; Thu, 05 Jun 2025 13:24:08 -0400
X-MC-Unique: NDUfdS8uODC0KhQ9uSCnMA-1
X-Mimecast-MFC-AGG-ID: NDUfdS8uODC0KhQ9uSCnMA_1749144247
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7377139d8b1so1183779b3a.0
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Jun 2025 10:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749144247; x=1749749047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NilGyannDkSG1qdzHF1/Z/9qZ2bbYcqHW2ABfSOqUNg=;
        b=VkRaSsDyNihhSaYNmKRqmQXZ2FphjWscHAl9WP6ZH6pY4SkM/4DNEiWEG6S/BIb09Q
         vVY1G5fJvg1IDF8Cq6WIEwL+P0VHRZ+wZYZuDDdd/R7wMwLlP3v88P6q+ElfetPMjnqx
         51s8rgidJv9wGIazHk134urMiW7dUbc7in4s/vCfuMKj+Q25mADWFSUQ2fgB4Pvdmv0K
         V63Fawut2t/ewrZWre1pHZJHLteDAIMogVkXiEnqqf2DYqYlFZ/ocBNQlRScfrKHVIb/
         6pRSQwecSwXC07VIynHv7waext884lODTbBWS6ocgl8zmV811fNRODAi53/W6zKegm59
         KNyw==
X-Forwarded-Encrypted: i=1; AJvYcCVhWUAribKR7l5CtMr69Prl7ZorLirP3ix3cyVFXSBBT+Ezr8Dk8pU8HTcsHKQUyrHpnPQLf07CGk3YWRdf@vger.kernel.org
X-Gm-Message-State: AOJu0Ywzv8+hVePGhRNKNfudK9M3NeBHrkO/Ypj0YEkN5y2c2TW0iTJ1
	1dj//w5Hy72ueUhTO5NkVORspgh3utgggAcykeVFLh0x5jEUz7J+zWvOo0aTQfoZ7mOYKPyZlkv
	RjefBBg9ddNzcyVv9/CCUKfKqVTxUy3tU/9vUT1UARRVWUslwQwZNyKmWp2SEowEBnSB5+/CSDk
	0o2w==
X-Gm-Gg: ASbGncsW/zT9cblFsTjHOP/rmwv31cw/AnnQlT+kmIDDmq1aLm10rpONVAeVyK2iN8K
	+6kDSZT1/GiaHBzjeJuei1UHCmzfwViwLFbIE9AgrwtFHl0D5mHbPUn60pguMucfpVLEuEszNzv
	g+xcTZmVvZSpQl+iMsIBE3hqoLosyQv7IJZgEm+NhCQV/QUI28z0nUXfHXZtucpCFaZc8qmveGa
	DW2HTdKrhb/uvjy8iFj2ClN0voMr61AxBMLVRr8iQlUuEdvkLp4KYql5MeD/fW9+1Mya7xAZdz3
	zxuMCwXk88DVgBYP6Tm13ZN8wgvpHlu1/tUV1RtMpvN4o1kIl3qe
X-Received: by 2002:a05:6a00:882:b0:740:b3d9:c889 with SMTP id d2e1a72fcca58-74827f309acmr683755b3a.22.1749144246791;
        Thu, 05 Jun 2025 10:24:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFSQoVwsczuKqqBTzijzTKvkEvwy43OL6IAzBrfLN/FFYyL4P4R/+ZLi56/LOch2dVUXhGGQ==
X-Received: by 2002:a05:6a00:882:b0:740:b3d9:c889 with SMTP id d2e1a72fcca58-74827f309acmr683725b3a.22.1749144246404;
        Thu, 05 Jun 2025 10:24:06 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-747afff7407sm13428524b3a.178.2025.06.05.10.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 10:24:06 -0700 (PDT)
Date: Fri, 6 Jun 2025 01:24:01 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Anthony Iliopoulos <ailiop@suse.com>,
	David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH v2 5/6] generic: remove incorrect
 _require_idmapped_mounts checks
Message-ID: <20250605172401.v7lpervaq6bbxgn2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
 <20250603100745.2022891-6-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603100745.2022891-6-amir73il@gmail.com>

On Tue, Jun 03, 2025 at 12:07:44PM +0200, Amir Goldstein wrote:
> commit f5661920 ("generic: add missed _require_idmapped_mounts check")
> wrongly adds _require_idmapped_mounts to tests that do not require
> idmapped mounts support.
> 
> The added _require_idmapped_mounts in test generic/633 goes against
> commit d8dee122 ("idmapped-mounts: always run generic vfs tests")
> that intentionally removed this requirement from the generic tests.
> 
> The added _require_idmapped_mounts in tests generic/69{6,7} causes
> those tests not to run with overlayfs, which does not support idmapped
> mounts. However, those tests are regression tests to kernel commit
> 1639a49ccdce ("fs: move S_ISGID stripping into the vfs_*() helpers")
> which is documented as also solving a correction issue with overlayfs,
> so removing this test converage is very much undesired.
> 
> Remove the incorrectly added _require_idmapped_mounts checks.
> Also fix the log in _require_idmapped_mounts to say that
> "idmapped mounts not support by $FSTYP", which is what the helper
> checks instead of "vfstests not support by $FSTYP" which is incorrect.
> 
> Cc: Yang Xu <xuyang2018.jy@fujitsu.com>
> Cc: Anthony Iliopoulos <ailiop@suse.com>
> Cc: David Disseldorp <ddiss@suse.de>
> Fixes: commit f5661920 ("generic: add missed _require_idmapped_mounts check")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Is this one changed anything from this ?
https://lore.kernel.org/fstests/20250526175437.1528310-1-amir73il@gmail.com/

Due to above link has been reviewed by Christian Brauner, do you want to
add his RVB to this version?

Thanks,
Zorro

>  common/rc         | 2 +-
>  tests/generic/633 | 1 -
>  tests/generic/696 | 1 -
>  tests/generic/697 | 1 -
>  4 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index bffd576a..96d65d1c 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2639,7 +2639,7 @@ _require_idmapped_mounts()
>  		--fstype "$FSTYP"
>  
>  	if [ $? -ne 0 ]; then
> -		_notrun "vfstest not support by $FSTYP"
> +		_notrun "idmapped mounts not support by $FSTYP"
>  	fi
>  }
>  
> diff --git a/tests/generic/633 b/tests/generic/633
> index f58dbbf5..b683c427 100755
> --- a/tests/generic/633
> +++ b/tests/generic/633
> @@ -12,7 +12,6 @@ _begin_fstest auto quick atime attr cap idmapped io_uring mount perms rw unlink
>  # Import common functions.
>  . ./common/filter
>  
> -_require_idmapped_mounts
>  _require_test
>  
>  echo "Silence is golden"
> diff --git a/tests/generic/696 b/tests/generic/696
> index d2e86c96..48b3aea0 100755
> --- a/tests/generic/696
> +++ b/tests/generic/696
> @@ -17,7 +17,6 @@ _begin_fstest auto quick cap idmapped mount perms rw unlink
>  # Import common functions.
>  . ./common/filter
>  
> -_require_idmapped_mounts
>  _require_test
>  _require_scratch
>  _fixed_by_kernel_commit ac6800e279a2 \
> diff --git a/tests/generic/697 b/tests/generic/697
> index 1ce673f7..66444a95 100755
> --- a/tests/generic/697
> +++ b/tests/generic/697
> @@ -17,7 +17,6 @@ _begin_fstest auto quick cap acl idmapped mount perms rw unlink
>  . ./common/filter
>  . ./common/attr
>  
> -_require_idmapped_mounts
>  _require_test
>  _require_acls
>  _fixed_by_kernel_commit 1639a49ccdce \
> -- 
> 2.34.1
> 

