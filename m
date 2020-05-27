Return-Path: <SRS0=jndh=7J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE76C433DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 03:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7724020787
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 03:20:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qVX+9QgT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgE0DUO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 May 2020 23:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728337AbgE0DUN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 May 2020 23:20:13 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E327C061A0F;
        Tue, 26 May 2020 20:20:13 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id m12so24699218ljc.6;
        Tue, 26 May 2020 20:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=M4ivFc6kSqZpz+3LE91PokU5ZJbEXVZ2EsPOUaC4dhY=;
        b=qVX+9QgTA1TTshe+kZIDXoWDs317hKbvdqNnCQWtb7x6JtJWq6rjAwDCRLyxSUq+fo
         nzSz7o+nvcfekosvxrksB3D+jy2iK4mRFm9amTSWQ9D2BSNmaG0smLDaYf9X86WNv4wE
         Di4PKGQ0aqoM44qCpcDAZvXQdc1L9dRAf1NLrm3CQTBG780xCk4u3s7VmFs0f3Y1XUUQ
         T5Lglnym8hk396hGCpoLSbWgoS6gWvqkSYL83GbdTdX9EMjWZhh+/jjBM4y2waEl1lb2
         mrO9aDFdsAauUxSznpm+pdO4r0JCSGRlMOVOMC4dn6VND8tD9fiOC0w0hjCo/6QkztaF
         foiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=M4ivFc6kSqZpz+3LE91PokU5ZJbEXVZ2EsPOUaC4dhY=;
        b=Z7mWq7K9m2WGNiq6bMCpb467kxUcUIdCQrjHAGgK+JTFrOHJpwPeKecZb5QCCJkryI
         /P51E1uXXFpWnvT6kO99PZdp9KwA+nW34Kvh2MWVATRIXJk/GV+Ce7+T7OJuy+dD17en
         ANUze76ZEwrOfxPQFyNTqMO4SiPrMETvMCAJwUwkgIBuX9/0B1LJ+x4QRjVFLr7K4gXl
         h6z9h3M1uBLjHM46JVP/1ITfQcgb6OzggKD9itUjRTcKKW/pBeyg03zSGfsX4+mVtQ3d
         hcoP4Mvti64NbW9K2Sd6queAL6137oLqeHHAgyA4OKzVyNYWl6rvYjymOSalgpMBeAvN
         CaPg==
X-Gm-Message-State: AOAM5322fLVAzkSAkfaAE7/4IkrpMGciaHfk/KBA6LvTq7gV0bqENI5Z
        QNU2xjWovXuOa9J7b0+Pa7u51OBf
X-Google-Smtp-Source: ABdhPJxlKJksh42ODi3NAFjb33hSrwKE6d28v3+/8EzCeJhy/9Uy3cnkpWbOcC4GAsuXaQoa+N8Fvg==
X-Received: by 2002:a2e:160e:: with SMTP id w14mr1903821ljd.66.1590549611902;
        Tue, 26 May 2020 20:20:11 -0700 (PDT)
Received: from localhost (cpc158779-hari22-2-0-cust230.20-2.cable.virginm.net. [86.22.86.231])
        by smtp.gmail.com with ESMTPSA id x8sm373160ljh.97.2020.05.26.20.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 20:20:11 -0700 (PDT)
From:   Yuxuan Shui <yshuiv7@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] overlayfs: initialize error in ovl_copy_xattr
Date:   Wed, 27 May 2020 04:08:02 +0100
Message-ID: <874ks212uj.fsf@m5Zedd9JOGzJrf0>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


In ovl_copy_xattr, if all the xattrs to be copied are overlayfs private
xattrs, the copy loop will terminate without assigning anything to the
error variable, thus returning an uninitialized value.

If ovl_copy_xattr is called from ovl_clear_empty, this uninitialized
error value is put into a pointer by ERR_PTR(), causing potential
invalid memory accesses down the line.

This commit initialize error with 0. This is the correct value because
when there's no xattr to copy, because all xattrs are private,
ovl_copy_xattr should succeed.

This bug is discovered with the help of INIT_STACK_ALL and clang.

Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
=2D--
 fs/overlayfs/copy_up.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 9709cf22cab3..07e0d1961e96 100644
=2D-- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -47,7 +47,7 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 {
 	ssize_t list_size, size, value_size =3D 0;
 	char *buf, *name, *value =3D NULL;
=2D	int uninitialized_var(error);
+	int error =3D 0;
 	size_t slen;
=20
 	if (!(old->d_inode->i_opflags & IOP_XATTR) ||
=2D-=20
2.26.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEL6EJkr0WlitWahBy06RAW+bMF/QFAl7N3FkACgkQ06RAW+bM
F/RKGg/+Mal8/fZGFJmB4SjmletMefSDfnlLnsTfMQC75ZepOCCixJQG+7+DGH1b
T3QsqDVBpl8W73SGGqo/45FewG7zD2Yedmg9SdFUwQsLVfXA+QhH0umAehO1MAG7
3jhn4jEC7YL5RRhc0BwSbrQA+1N9Mq4UBn0aai1W+dhbsibY86EIvpaJzZzT/Btc
BrxOtM522VtL6ZGxuz5tfSn1yQxNMBGB754q0wP7b9xo79ImNHcNnOUaqFCWVcOc
W/B0ThhhJALiP/GEa+cuRzdRYfR6JmASW/EoCHzHkZ6YWgf4inRD/hF/4Ml/p++W
aQAxyiRsiUUmEQUD4vGcYQa4ssBsiengGM++c7VoqKX+TGtxKCOGfed8/W6A2CLV
62yMEA477fKvpU2mLa3XuJptyoqr3hNb00JNKBj/Z9cuDOn9mxjYbdYyQlSlH3XI
2kj5cW1hfhdvvoDIWrE1lUzhGsXac6KS5MPh2vJL6DobJDOEoNI2o8hWN9fplPpr
TjtszOyFuFuwRDURfhl/4/80i/T7jcbGR0SLkNkB5s2Ic7u8lLJRrqyb9JLeGJI2
ExJ650h9rsg5QWvx2LEpI21TX8XbCorwc1zCHpghCijO3qUg0eTXmYHevmZXK7DH
GYQJVI35TFHxIBvFM+Wo/Nl+OB0iaeFePOe3G0j6oVPHOsW7oIk=
=nXDi
-----END PGP SIGNATURE-----
--=-=-=--
