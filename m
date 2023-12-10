Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LvAm9y21"
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB08EFC;
	Sun, 10 Dec 2023 07:28:46 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id 006d021491bc7-59064bca27dso2130250eaf.0;
        Sun, 10 Dec 2023 07:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702222126; x=1702826926; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SI+pHJDVosXm+kgcqig4M+PjMjleFB4C6hfewiK+1qc=;
        b=LvAm9y21jB2Xq2xbItEFBsw5LW1JdkZbKkpZOUSf20cC/sfkL+qRbN6fJCYwXVA9Y5
         Er8RLe59P1eGT6CmYN7SLguyBdVfceJnqmxP7ddvtdVbRKdl9UBXKJ10BKevFsBqGVsf
         75iK4Gsz0b7VA7iJ4f2f4Qa+fgIdnAEtoX6j6dkpAgJqTBfyzCE7JaBbEKN6Ghaljh1r
         HztpauQBxQdsZAb05+C75/csBzm5Fcj93K5gBHT5A+xtw3Gr0Nqz8nbitefZ55ItP+YU
         1VM6eUktaapBo3LGw90Z6bqlNNc4j5sQfHvrOPmGQZM5nOraIOYLGNhHxmz/oro9aZo2
         JjQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702222126; x=1702826926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SI+pHJDVosXm+kgcqig4M+PjMjleFB4C6hfewiK+1qc=;
        b=ExuTDEqCUqTAtyjGIpKWXrfayrIFmSbJ8PxZSku6DLi9+OdG07LOGC2xreYB/HzNsj
         DwOz/E6OL3zXg89S5WX9lP4X42HudKDC8SEiT57UjV7PZP5pVI4Hu/r25xHEoeaUmNeh
         UhkFKbpGDvlcBfeOcds/Gt9yf3j0UoKPdzJOqrvnJVyyn9/5d39Xs4uSnGkw5YUks/3R
         FVrN20ACTDxQuxRxnaCO3IF/FZCNG5K92BzU2bVv+H1oMC0NN4C++G34HLSIrTN6/F8t
         atxZk1m22S0PzZ7ub8ZUpRihmgeoYKujltrA9RWuroP8atRCRlUQyfKjMhtA7gPOYQmd
         W+Rw==
X-Gm-Message-State: AOJu0Yw2g4llmfuGZDoRSaHZCDgo6lC5+97aSn4IlFsh74ogbHhD8i1G
	1ucs5MKEJh5i+fg4qa79V6hgvo01nvVA9NKUTuo=
X-Google-Smtp-Source: AGHT+IE+7M81IcxaUQviAv73djQgID5y4JUnT/i+tVNe1jvUwB856N8HDajM7pCox0OJGzKG+xmgf0XSwJRH3vkYea8=
X-Received: by 2002:a05:6358:7f05:b0:169:9c45:ca12 with SMTP id
 p5-20020a0563587f0500b001699c45ca12mr3606561rwn.23.1702222126061; Sun, 10 Dec
 2023 07:28:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231204185859.3731975-1-amir73il@gmail.com> <20231204185859.3731975-2-amir73il@gmail.com>
 <20231210133526.ei7thr54dff6zjbz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20231210133526.ei7thr54dff6zjbz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 10 Dec 2023 17:28:34 +0200
Message-ID: <CAOQ4uxgkb4XfStSZkK0ZLk0tAdN60rf5YCMhaXrHzm-wJsP6hg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] overlay: Add tests for nesting private xattrs
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 10, 2023 at 3:35=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Mon, Dec 04, 2023 at 08:58:56PM +0200, Amir Goldstein wrote:
> > If overlayfs xattr escaping is supported, ensure:
> >  * We can create "overlay.*" xattrs on a file in the overlayfs
> >  * We can create an xwhiteout file in the overlayfs
> >
> > We check for nesting support by trying to getattr an "overlay.*" xattr
> > in an overlayfs mount, which will return ENOSUPP in older kernels.
> >
> > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
>
> Hi Amir,
>
> This test passed with below kernel configuration at first:
>   CONFIG_OVERLAY_FS=3Dm
>   # CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
>   CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=3Dy
>   # CONFIG_OVERLAY_FS_INDEX is not set
>   # CONFIG_OVERLAY_FS_XINO_AUTO is not set
>   # CONFIG_OVERLAY_FS_METACOPY is not set
>
> But then I found it fails if I enabled below configurations:
>   CONFIG_OVERLAY_FS_REDIRECT_DIR=3Dy
>   CONFIG_OVERLAY_FS_INDEX=3Dy
>   CONFIG_OVERLAY_FS_XINO_AUTO=3Dy
>   CONFIG_OVERLAY_FS_METACOPY=3Dy
>
> Without these configures, this test passed. But with them, it fails as [1=
].
> The underlying fs is xfs (with default mkfs options), there're not specif=
ic
> MOUNT_OPTIONS and MKFS_OPTIONS to use.
>
> I'll delay merging this patchset temporarily, please check.
>

good spotting!

Here is a fix if you want to fix and test it in your tree:

diff --git a/tests/overlay/084 b/tests/overlay/084
index ff451f38..8465caeb 100755
--- a/tests/overlay/084
+++ b/tests/overlay/084
@@ -50,9 +50,10 @@ test_escape()

        echo -e "\n=3D=3D Check xattr escape $prefix =3D=3D"

-       local extra_options=3D""
+       # index feature would require nfs_export on $nesteddir mount
+       local extra_options=3D"-o index=3Doff"
        if [ "$prefix" =3D=3D "user" ]; then
-            extra_options=3D"-o userxattr"
+            extra_options+=3D",userxattr"
        fi

        _scratch_mkfs
@@ -146,9 +147,10 @@ test_escaped_xwhiteout()

        echo -e "\n=3D=3D Check escaped xwhiteout $prefix =3D=3D"

-       local extra_options=3D""
+       # index feature would require nfs_export on $nesteddir mount
+       local extra_options=3D"-o index=3Doff"
        if [ "$prefix" =3D=3D "user" ]; then
-            extra_options=3D"-o userxattr"
+            extra_options+=3D",userxattr"
        fi

        _scratch_mkfs


Thanks,
Amir.
