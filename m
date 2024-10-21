Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CA81E633C
	for <linux-unionfs@vger.kernel.org>; Mon, 21 Oct 2024 10:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507466; cv=none; b=CKvGQ51gqVckQbpDg2GdTeRKKAdjy9kbVggHpYitEijLZF+luLUHH7Of4CrWhUun7j+Yvc3kLDGmnYDUkpRXlCgvMf/VhQn0RERbPHsHdh6cbyzCHD34KneWc+Vldwvs2HNASkXDxcd0o/xqS7DUO89Ssl1izEIKkWnGgGpgpJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507466; c=relaxed/simple;
	bh=H2b5ATnt5E1Bo99qJUPFpUnk+M1Jkx9D2jNgd7IjZq0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=czrlQEIWC1/zwlC+B71DYw+LcfoRZlh9ItEvh1MfP2Lkm/OI69mPvBKccSP051TqVgdmIsvNZ2Vo540wYUUWZxuOzDd+FU+JhgBGNtFwb4uwTr3TIg8tfpKzpySm0BDXH68hBNmCLRbOO7z5G5KigRtsb2EGTkMWoUbD1OtNd+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=hInj7tL3; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="hInj7tL3"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e297c8f8c86so4129241276.2
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Oct 2024 03:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1729507463; x=1730112263; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vs3ZdfEcKn0zVCu2kMdMdXvQgCQLkEnwi8nZT4fN4jU=;
        b=hInj7tL3sbvSYbaqfa+woB+0wOehgZ3iIBiPQnzI+A9J8yxd56/WGDPc1f24IJmgGG
         Wt+SK6p2HTk/5nVEJj7v+pqeY6ZySHj89yRBLOnmP7rm39skuDD5vU1lclwEHPIwOwfK
         pL38N5GPaLZqdG50ilz+muaGfLYU+TxhoLs8c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729507463; x=1730112263;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vs3ZdfEcKn0zVCu2kMdMdXvQgCQLkEnwi8nZT4fN4jU=;
        b=VvMvCVFGTA+r+vl/PYgNVLm5B1aPgnFAM6sEbGjqMgf56KPdkgADOPg666q7BucPXM
         +ykFz9P2oAT+gOKYpZnufGLjZIFtzIzV0ERt8539d9wnwmYG54dS3M5ti2c/fVXPeak4
         nhfmW1dgcmuEHw0/AjmkLCn0F3LR6wAxlSYktwVLoAt/YH609WIRJXYmmNNsIDkYvo4y
         H/8Eb6PRznH8PPv5uIQpbo7WeUY7c2zfvo9iFurj1xAlbhavNkyUOMljDkmQZP9kKwV9
         1FgwqqpCHxgfiXOP51A6IewN0rpwJWVnmzz5SWgjeNY8my6fdm/TyVL4dAUOOMSgNF7j
         fXeA==
X-Forwarded-Encrypted: i=1; AJvYcCXiZ1whuX/vKL3dm/JD9l0qD5sGIOnFbFPQUi0mvka1jr+Xk1Van+FDQhqdFWrL1GwLEZZC76p0+ZkPOAmS@vger.kernel.org
X-Gm-Message-State: AOJu0YwTn4Cm8inn3prk3fRPddhxik/KeIGaYhfXK6Yd9EMjzZ0t7ofL
	jUOey3sXcmkVV4Vz9wbZnPIEvqAP41fLwAVTa8wpYg2INmhjtK9ykHTPd5myKzEPY6wI8+4s2J6
	Pk0L4Ilw+ar0em5qcwOsLPFq93QpePHy8dsq6vw==
X-Google-Smtp-Source: AGHT+IE5yZTlevVj1gZ0L4e8USuUUJStmlno7fmxxSe+Cq60ncfQcAuXIHI98/H4B2hU2sPtzF8Qa3zYhBs6Q0vxqhU=
X-Received: by 2002:a05:6902:2848:b0:e22:65ee:9a17 with SMTP id
 3f1490d57ef6-e2bb168d098mr9421782276.44.1729507463548; Mon, 21 Oct 2024
 03:44:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241015133141.70632-1-mszeredi@redhat.com> <CAOQ4uxh-3H4QkTEihujFgz53ajeArWH9u_yj4kaWByVJAGmgrw@mail.gmail.com>
 <CAJfpegsfMf_On1qAmv1Qeud2MkFJcL1Q0Kk_i58h7YcOoVbpgw@mail.gmail.com> <CAOQ4uxi_ir+KdiAHhLC6_J617KJQo9Ve2rscQXJ1ws6EVg43cQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxi_ir+KdiAHhLC6_J617KJQo9Ve2rscQXJ1ws6EVg43cQ@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Oct 2024 12:44:13 +0200
Message-ID: <CAJfpeguaf99y1QdvXzNXuxJJAw_UaMrpYoXrB=ZuSb8+EAf9Og@mail.gmail.com>
Subject: Re: [RFC PATCH] backing-file: clean up the API
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Oct 2024 at 20:57, Amir Goldstein <amir73il@gmail.com> wrote:

> But I think that if we aim for a cleaner interface then the arguments of
> backing_file_splice_{read,write}() should be similar and so should the
> arguments of ->{end_write,access}(), so we should change
> ->access(file *) to ->end_read(iocb *)

Changing ->access() to iocb would mean having to manufature an iocb
for mmap(), which would be unnatural.   So I didn't touch that.

Thanks,
Miklos
