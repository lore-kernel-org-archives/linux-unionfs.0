Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CqJXs+BJ"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77105D7
	for <linux-unionfs@vger.kernel.org>; Sun, 10 Dec 2023 12:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702241111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EySkhJB2rvVc5bqC/vysraakaT/UVaxU4Dy1S4Skp2w=;
	b=CqJXs+BJ82vlb17nnx0iOlXLSDuLPVe0yetBSS7vR9cr6eHlwuQVQGnqHwM8xMICqogJXp
	Hs5yj+lTbZQztXtlwSewEgjV0wnwu08D9fpr7zxyaEA4tPxCjkkSYfsEpsUvXZygNax+Lp
	6CCrs40EU/EXNuL9kgs+XEwjwd0iGgU=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-EKjy0_4WNRmXLW3tdT4Pcw-1; Sun, 10 Dec 2023 15:45:08 -0500
X-MC-Unique: EKjy0_4WNRmXLW3tdT4Pcw-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-1fb130800b4so6846033fac.0
        for <linux-unionfs@vger.kernel.org>; Sun, 10 Dec 2023 12:45:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702241107; x=1702845907;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EySkhJB2rvVc5bqC/vysraakaT/UVaxU4Dy1S4Skp2w=;
        b=DvLlqNejlM1uWf2HYfgBdER72T+wH6cDFf+F6nTPBRZiWoS34tUBBUSVhDyMSAcuCt
         r1siaui42eZ3iZSdpa40SfaUnL7I4ic3HggWhc7HM6RMQwi7LoLp/gxAF9tDYrOArwDU
         QVxC+jr4PMxOYflNu+Y3SqWOjI00hBBGQVnptaZD/gmvi1vHgEfAd3b/eFgP04iibn83
         lzRo7NY0/bdivoQFMIbZrDPepdu7l3R6//4rCcIFzoqjFEqyZVFNYXXh9JJw2ihhkWEZ
         De4a3yz8fRcO1kT89tOINydWkgLsC8DEkJpqyAcrt80b0vm6QFHALaIdRwjA7VsP/fna
         qC8Q==
X-Gm-Message-State: AOJu0YwtXVTDZW93/VYLPqBMTQBDVsLJqyPQcV1D4EmGtl3Jnbevpurq
	AHj5pv2oOPQrP4aeJ1+curhy5HalRi9EJs+XpryiA1kf2fY0HFnbxmewBDgZ4mMRvEACB//wqz5
	I6uWdAnkQO5j4VMcBUA5ai6rvng==
X-Received: by 2002:a05:6871:8285:b0:1fa:fa54:4d4d with SMTP id sq5-20020a056871828500b001fafa544d4dmr3940894oab.33.1702241107506;
        Sun, 10 Dec 2023 12:45:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEKtYpil2ulx0Q8EkoFKhe8Br4LvLHwQC6PRav8fZQ2MHS/dg2DPcQNOLKkhHCPvxLwYtmKVg==
X-Received: by 2002:a05:6871:8285:b0:1fa:fa54:4d4d with SMTP id sq5-20020a056871828500b001fafa544d4dmr3940886oab.33.1702241107181;
        Sun, 10 Dec 2023 12:45:07 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c11-20020a630d0b000000b005c2185be2basm4981285pgl.54.2023.12.10.12.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Dec 2023 12:45:06 -0800 (PST)
Date: Mon, 11 Dec 2023 04:45:03 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v2 1/4] overlay: Add tests for nesting private xattrs
Message-ID: <20231210204503.poggjg4z57eg2nn7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231204185859.3731975-1-amir73il@gmail.com>
 <20231204185859.3731975-2-amir73il@gmail.com>
 <20231210133526.ei7thr54dff6zjbz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxgkb4XfStSZkK0ZLk0tAdN60rf5YCMhaXrHzm-wJsP6hg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgkb4XfStSZkK0ZLk0tAdN60rf5YCMhaXrHzm-wJsP6hg@mail.gmail.com>

On Sun, Dec 10, 2023 at 05:28:34PM +0200, Amir Goldstein wrote:
> On Sun, Dec 10, 2023 at 3:35 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Mon, Dec 04, 2023 at 08:58:56PM +0200, Amir Goldstein wrote:
> > > If overlayfs xattr escaping is supported, ensure:
> > >  * We can create "overlay.*" xattrs on a file in the overlayfs
> > >  * We can create an xwhiteout file in the overlayfs
> > >
> > > We check for nesting support by trying to getattr an "overlay.*" xattr
> > > in an overlayfs mount, which will return ENOSUPP in older kernels.
> > >
> > > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> >
> > Hi Amir,
> >
> > This test passed with below kernel configuration at first:
> >   CONFIG_OVERLAY_FS=m
> >   # CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
> >   CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
> >   # CONFIG_OVERLAY_FS_INDEX is not set
> >   # CONFIG_OVERLAY_FS_XINO_AUTO is not set
> >   # CONFIG_OVERLAY_FS_METACOPY is not set
> >
> > But then I found it fails if I enabled below configurations:
> >   CONFIG_OVERLAY_FS_REDIRECT_DIR=y
> >   CONFIG_OVERLAY_FS_INDEX=y
> >   CONFIG_OVERLAY_FS_XINO_AUTO=y
> >   CONFIG_OVERLAY_FS_METACOPY=y
> >
> > Without these configures, this test passed. But with them, it fails as [1].
> > The underlying fs is xfs (with default mkfs options), there're not specific
> > MOUNT_OPTIONS and MKFS_OPTIONS to use.
> >
> > I'll delay merging this patchset temporarily, please check.
> >
> 
> good spotting!
> 
> Here is a fix if you want to fix and test it in your tree:
> 
> diff --git a/tests/overlay/084 b/tests/overlay/084
> index ff451f38..8465caeb 100755
> --- a/tests/overlay/084
> +++ b/tests/overlay/084
> @@ -50,9 +50,10 @@ test_escape()
> 
>         echo -e "\n== Check xattr escape $prefix =="
> 
> -       local extra_options=""
> +       # index feature would require nfs_export on $nesteddir mount
> +       local extra_options="-o index=off"
>         if [ "$prefix" == "user" ]; then
> -            extra_options="-o userxattr"
> +            extra_options+=",userxattr"
>         fi
> 
>         _scratch_mkfs
> @@ -146,9 +147,10 @@ test_escaped_xwhiteout()
> 
>         echo -e "\n== Check escaped xwhiteout $prefix =="
> 
> -       local extra_options=""
> +       # index feature would require nfs_export on $nesteddir mount
> +       local extra_options="-o index=off"
>         if [ "$prefix" == "user" ]; then
> -            extra_options="-o userxattr"
> +            extra_options+=",userxattr"

It works, so it's about the CONFIG_OVERLAY_FS_INDEX=y. I've releated fstests
v2023.12.10 version, this patchset will be in next release. Will send a new
version with this change?

Thanks,
Zorro

>         fi
> 
>         _scratch_mkfs
> 
> 
> Thanks,
> Amir.
> 

