Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KIArSytD"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CE510DA
	for <linux-unionfs@vger.kernel.org>; Fri,  8 Dec 2023 20:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702097376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kRC6E+82YXg5bJ8iGL1zYBpZDRpXzFFqlBgl+Fu1axk=;
	b=KIArSytD/tRZ9wJ0UEIdB6jIyBtBDYfpHxbDlieg9YzuVmZNgOfAYpAi3Ltp7BGczk8S84
	i0Iet1k7sFTH959wcXDEBxym7c9OVz4sa6Q74DYHbAoCzX8DeDoS2m9x/iQ8ZKjVQkEREi
	FUwcQcgu4Qw08JHzU9m44XurR0BV38M=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-QpD9EbFWOCaolChmm4Qw9g-1; Fri, 08 Dec 2023 23:49:34 -0500
X-MC-Unique: QpD9EbFWOCaolChmm4Qw9g-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-35d5db612c2so26119225ab.0
        for <linux-unionfs@vger.kernel.org>; Fri, 08 Dec 2023 20:49:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702097373; x=1702702173;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kRC6E+82YXg5bJ8iGL1zYBpZDRpXzFFqlBgl+Fu1axk=;
        b=iB7JJcOs3oIRfrcroi/hA+59VhcHvz5CnYoP0EQxQXOzd4qfIsD3PyyCbRMa/gUGCB
         rtVUlBAcgYa+pAlPniYfWjvw+LpUJj8V20XBRWhKX6T6w0kGN8vukm/N3UyIHy5JGHwi
         wZk+Lcxp4apC+9TQPkoBP8EFUsAILcwyHAEavPc0bleRepq8Wq7PbmNbwo8vAVg8GiTw
         /W2wI3Sxzf5wSvyzalfsChp7GkZe/kjoIr9QROpedPcQVy6TLmRtRtAbsFqHf3fbWfJG
         4WwnowJlhtPoTzjhofEEerIBHvmPr0Y189sF/xJ2dm7YteahmNU1mJZ5zg0x2kAmgP3o
         QeRw==
X-Gm-Message-State: AOJu0YxkFPmDmYQTqnopBidbVkFi+XPIiee90A7WmGyItZZF3GfTVsRe
	YqaUwQsyJHOt9foSwgMQ6RgzqJGt1NNYnxNoMvpIR1qWNolWxGm7GEJqliPrFxl73C3gmhzyTNW
	jg+eAEQvvrKwl/D0+CfK/odkxey6WEtfWnOKP
X-Received: by 2002:a05:6e02:168a:b0:35d:6579:7135 with SMTP id f10-20020a056e02168a00b0035d65797135mr1804636ila.36.1702097373350;
        Fri, 08 Dec 2023 20:49:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFKUV10bCyeVicYQqpK5S9zZPrhV9FtzcSQg5Gdzr7SSyWuUzn93zvenn5f3rlrhLuYyk38Rg==
X-Received: by 2002:a05:6e02:168a:b0:35d:6579:7135 with SMTP id f10-20020a056e02168a00b0035d65797135mr1804630ila.36.1702097373119;
        Fri, 08 Dec 2023 20:49:33 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h8-20020a170902680800b001d0828f2ebfsm2586381plk.273.2023.12.08.20.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Dec 2023 20:49:32 -0800 (PST)
Date: Sat, 9 Dec 2023 12:49:29 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Overlayfs tests for 6.7-rc1
Message-ID: <20231209044929.oogoausuhan5plzd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231204185859.3731975-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204185859.3731975-1-amir73il@gmail.com>

On Mon, Dec 04, 2023 at 08:58:55PM +0200, Amir Goldstein wrote:
> Zorro,
> 
> This update contains 3 new overlayfs tests for new features added
> in v6.7-rc1.
> 
> overlay/084, written by Alexander, tests the new nested xattrs feature.
> overlay/{085,086} test the new lowerdir+,datadir+ mount options.
> 
> overlay/086 was partly forked from overlay/083, but overlay/083 is not
> sensitive to libmount version, because the escaped commas test is not
> related to any specific mount option, so it wasn't copied over.
> 
> All the new tests do not run on older kernels.
> 
> Thanks,
> Amir.
> 
> Changed since v1:
> - Helper _require_scratch_overlay_xattr_escapes() already added by
>   "overlay/026: Fix test expectation for newer kernels"

This version looks good to me, let's have this feature test coverage
at first.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> Amir Goldstein (4):
>   overlay: Add tests for nesting private xattrs
>   overlay: prepare for new lowerdir+,datadir+ tests
>   overlay: test data-only lowerdirs with datadir+ mount option
>   overlay: test parsing of lowerdir+,datadir+ mount options
> 
>  common/overlay        |  15 ++
>  tests/overlay/079     |  36 +++--
>  tests/overlay/084     | 169 +++++++++++++++++++++
>  tests/overlay/084.out |  61 ++++++++
>  tests/overlay/085     | 332 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/085.out |  42 ++++++
>  tests/overlay/086     |  81 +++++++++++
>  tests/overlay/086.out |   2 +
>  8 files changed, 723 insertions(+), 15 deletions(-)
>  create mode 100755 tests/overlay/084
>  create mode 100644 tests/overlay/084.out
>  create mode 100755 tests/overlay/085
>  create mode 100644 tests/overlay/085.out
>  create mode 100755 tests/overlay/086
>  create mode 100644 tests/overlay/086.out
> 
> -- 
> 2.34.1
> 

