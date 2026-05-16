Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27EC37475E
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 21:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778965647; cv=pass; b=UBE2O3LDVH1cgnMutJd0uG4Dmakest1HbtNFy2/tGhB3bXiweNiKNqTpqZTEqlDBDZIGVkJGHZw+g+IdLLVfgaFNGiAUrQqnSgAyJ2FxiiAeCOMEAHj6g5NTd3jfw2IwffFWfR/1hX4xFMxJ4oMF/gcjnQ/ERzkby6iD2LEQaF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778965647; c=relaxed/simple;
	bh=Ub+P3WD2AiL8Wsq+6+qWAW9txbbRR19h/6iUeOy/S8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FnwcB6ZFxV5rxmRa2A5BwbZo9I/epHBYm7O7XOi/RllYmSz6NxIY1hpMCv0K2Gxevo483pZZGOBOBuOyWNY4Zd3W6TiTTNCcL7SXVTLt75a8a4TIhOzz57u1jfV/mUM5MkdT5J/Ghn1v5Ij7rCgwOavlkP5hdEju7gnCvzW2yvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BGoq9lU5; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BGoq9lU5"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-67bb5ad91bfso3054430a12.0
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 14:07:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778965644; cv=none;
        d=google.com; s=arc-20240605;
        b=U9HNWyeV2FK5ki8GpyK6HG1MJHE52HFRDYv7LNyX/VBp8hK5RinnWguMRf72oLQ3HT
         xjTDQuEy4L2E+tSxnIn40I6f7vNzddxP8HU9VPW1rtOYPiaisE2iMb6EgoNNUcdMZPTY
         sXAHpB3laBQYFfId/bnWqouOQuOzdTfZHHADlZUkFtFCSEOwhrS+dV0v3LuXJNn4fK8F
         oSW+4elnMR//c8f5uor/JwG+Wf8HsnaLLmZniL4NrrGncX4skXJTzwdSP0hXvqIsSWW2
         uygKJm/770TUZo8uuY4BbrunvkjiJ73fUmXJW5QCNSNsLOzyln3f2Gjnrx+ju8gdx25A
         bd2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vA5fGUzo6qOHwX+dosOCYZirrPaFcfzKm62zYljgqO4=;
        fh=EN46qWTqJJlqrtC4qu9vxyRN2rJ94L5O+9ME4WGdxNg=;
        b=aYOa1+IMKVnLTWyTsiJIDD1qTbw2S1O9VgIhj/OJ3gSHLxRQmVjaPwJaiPglQnGDqQ
         6oWSQO8VTSiwBDkQ4fGu7RAKfjPowEGwMCQtB5MQRotTryTqdV53hldHS/gjotRy3wrn
         F4YoNnIt9UWcidQdbQ0khOMrxEcqdEYRI2ZSMlLz0kQXTUxvhwRSvJCaR01ptJnDEnal
         mPgWlbtntImzfvO30p4CUIHHLKIbzZQuglYc81L33ckhCWVv/cxbEpOTSPADRrYaKXp+
         78eN6TQSdDuIuPjQQBLGx6g6IdOYZHO0+T7sL0zcBtnwsBuGdOIj1ga3q2O3qS3DmUY1
         8qEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778965644; x=1779570444; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vA5fGUzo6qOHwX+dosOCYZirrPaFcfzKm62zYljgqO4=;
        b=BGoq9lU54rbL4yOhOLJ7BpxtqeryFDGFpQ0rgzNBfQJeVAKGOehwQwEsNqr6pCRjns
         8ywi0VJ5ha6/VOpBK4XOUdGfsNMB1SkGYDFHZIwXXERsXN3iD6GDN7GxZW/afsvIHd76
         jUKYGAGCnJRdKLTvcM9+kdZ5O6zOPl5VCOclICtbjGMHGpQGlPY2bP5wU2DsLMj++p44
         55gYO3Jvby+b+dynmA6xnTBb0Gk8Bq0k9C960zfbO6q0LdKVCfruts4FJPVO52I7nVD5
         kAbqXfr0bDdYoXeLm+bVkpvMEosSOVU+wrv8VvZPI7WXPsJ2ZyHDI+bWYnM/ev7CtlMy
         FDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778965644; x=1779570444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vA5fGUzo6qOHwX+dosOCYZirrPaFcfzKm62zYljgqO4=;
        b=CqH125fHlTHn45DjqtAYRBy0yUIwNHbUFbnQHY5s2uyAOTwgx/lzcz1sTM9lQe2rZm
         mX/1ZOC9xQW9cen+Z9TnMfl7BbkEZGxIdue5tXYKQ303b67ClcYhjLUt6LY/TgU97JKe
         xorAO7yuGTzN8bplslDdsO9jpE8wvVwNLEgGHkssbNhNoRojNyYgyJMgPdWbmG3cFRYo
         IfqrtYBb9ZzdLdEjqzeA1HonnAKadwamFaetnixfYfZNOzSfIoPp3whOf+9anqN1wqNL
         dyNnsxYIT0MNHSPJ3HMVw3MsyzF/hNhTY/dTcpGeRTTtyITL6td3dS8DTHObApIExjQv
         2K5w==
X-Forwarded-Encrypted: i=1; AFNElJ9WNCGwy6DLlucbYTXmPCA5Rjm55728cgxVUrrz1sHZuf4gsH7TO5tASQZvOrgAL9JFgw4FbGXY6N9NFXpI@vger.kernel.org
X-Gm-Message-State: AOJu0YzUfnWdeZ3P75D4wa+KHfGWjIrc7E/XdbLL4HCShTO02MWdB8w8
	83XEQv2he6Qv2Y7zTos8ekiqkN01qULdTzfGQrzb4PrNKiDF5J9s7kCh3vOjj0b9QzuS5ridfwO
	634Pt+IznB7gLjXOhskMtQaRuasU0JZk=
X-Gm-Gg: Acq92OFrTnKbHIx3FELFZkiht3XNIUa0EYKFKqa0plSUeJRGnd4tDc20igTIAcqEeMD
	7vFTX/ckd9h2U3jKzQlV6DZMG/QuxAD5vb31tcnij+FgkiAgo3PDhEHpgjKRV/2aKgiFGaj40wX
	rgy1ssMWBCL6OYTjTokz30BpkoyFg1BL+Fsyu8enBpf2lERpyY769NvPf6BmNOcBFVdQMonfV0j
	QlCMwqsPgbIuAYIbpUFlzTCePprnbo8bdmKw9KSCZnv0P1Y9BUxkOW7p8RWB/sncImRd/5zepGc
	ZEvbb1TcIav/lp1jVnLHzjCq3wLDHerkMJltqduViA==
X-Received: by 2002:a05:6402:22fa:b0:67c:4e1b:9134 with SMTP id
 4fb4d7f45d1cf-683bd58b77emr3297996a12.14.1778965644110; Sat, 16 May 2026
 14:07:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com> <20260516004004.1455526-17-joannelkoong@gmail.com>
In-Reply-To: <20260516004004.1455526-17-joannelkoong@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 16 May 2026 23:07:12 +0200
X-Gm-Features: AVHnY4JLTteQ2t3JgElyBKG4KRzM1bELuuali_hsonXXpRYApxypRQE09arSvoE
Message-ID: <CAOQ4uxjZNfhY_NfS4B3EorqLdKRhzmTXEgKyPZJYwY_FaQdM5Q@mail.gmail.com>
Subject: Re: [PATCH v2 16/21] fuse: allow backing_id=0 in open to inherit
 inode's backing file
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 2:52=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> With FUSE_PASSTHROUGH_INO, the backing file is associated with the inode
> at lookup time. Allow the server to pass in backing_id=3D0 in the open
> response. On the kernel side, this uses the backing file already set up
> on the inode.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/fuse/passthrough.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> index d62a1c751157..ae0137caa06d 100644
> --- a/fs/fuse/passthrough.c
> +++ b/fs/fuse/passthrough.c
> @@ -193,13 +193,17 @@ int fuse_passthrough_readdir(struct file *file, str=
uct dir_context *ctx)
>   */
>  struct fuse_backing *fuse_passthrough_open(struct file *file, int backin=
g_id)
>  {
> +       struct fuse_inode *fi =3D get_fuse_inode(file_inode(file));
>         struct fuse_file *ff =3D file->private_data;
>         struct fuse_conn *fc =3D ff->fm->fc;
>         struct fuse_backing *fb =3D NULL;
>         struct file *backing_file;
>         int err;
>
> -       fb =3D fuse_backing_id_get(fc, backing_id);
> +       if (!backing_id && fc->passthrough_ino)
> +               fb =3D fuse_backing_get(fuse_inode_backing(fi));
> +       else
> +               fb =3D fuse_backing_id_get(fc, backing_id);
>         if (IS_ERR_OR_NULL(fb)) {
>                 err =3D fb ? PTR_ERR(fb) : -ENOENT;
>                 fb =3D NULL;
> --
> 2.52.0
>
