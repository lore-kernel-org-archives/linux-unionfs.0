Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333482E3700
	for <linux-unionfs@vger.kernel.org>; Sat, 26 Jul 2025 18:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753554484; cv=none; b=pA0G+VtqYhLeCW1PARGMuRmMu+oUVyEE0XPKijT4/I7OPBAQY4JE7rDvrFvp/4vy/3X3vRzFa8DhHztKIj74/x2Pko0Ks2rXnUh6LH6KlZn9ZzcOChRtV6+GfGB1zMl6tvQbBRrM7C8LoEf0WaeabPwZDSfPXBLS6u2XLkUfMcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753554484; c=relaxed/simple;
	bh=5FpVyPwCZoukTXOde96eN5IMURDrrl6rnwTspnk4CLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aALuA/epBHAeLZr9YGNncEIusFjzE0Z4yfXoVLWLiG4eBTPo0Bs2GBK22pvcAPUsgRfTLJ7o4u6PTPlvERXSLTJWNv7U1We+6hFDqepTpblWr8oIkoJaaM2lgzCqDHfSLCdemk+QYRWx0dsFzAgz4YirAdd+su8pTrK+KLIv/F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G43CffcF; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G43CffcF"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-605b9488c28so5377459a12.2
        for <linux-unionfs@vger.kernel.org>; Sat, 26 Jul 2025 11:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753554481; x=1754159281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ECsDz2UG90AF1ii9kuCJLtmMrK7v4Pq/1bXNgpLo2sg=;
        b=G43CffcF9PDunYE1rHO4MGuJSCZKCwzF1za63mrQqBQVvMaPihm3GD+OFnYXjhQvCo
         SVQRRc62/95KD+pFDJ1/NlL/B8VQsLSWsjPCWWA3J5TtGrI8VpO9HysPdc+zg7WOekm8
         lekkhTx7/ABQFwcuFWdCM9mLDDrT/VICSiPuOzkNQwQMICzKYRvV8ijUXezGqADpeIV5
         +Xt+fwmHQnL/Smx142e8dneZOnmoxfTYPOshw62ikMkeKzUUCwFkxTbnLQmypULNFhhQ
         69ZJ/LjGr8CJVmznlU1/y28WgoAQz3IUg9FNlfvK6pq6DCm5ep0I9vApBiXOxodf9uWa
         KKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753554481; x=1754159281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ECsDz2UG90AF1ii9kuCJLtmMrK7v4Pq/1bXNgpLo2sg=;
        b=P6WnXgv5IVx2KmDa6ICBXPfVNLYLENX+g4xw4zA7rcORGF3Dd6p6oVmJNmBYEZnPRN
         8Fz4okytlH1Ejx+eZ01HrH62Q/gg3WyW/qIbpmmwE2Ox+s6+d/OAxkm9WvpqpORKA9Iv
         4bkoyRh2r7FJsLMrfKWpWukJ7IvQvQIJpX3zymR4ntGVNwrWy3GvKtAbDzLHHiCCIfQu
         I2IzDbSO7IYNfZoqQtmwUHO4ZI9wfDzSuIzYg9b6cPHsnzyQuEIs8JbxNOwiCN2CT+us
         9MrR+izG02ZqxWUSRodto3oM5iHxF8v9rbK722DuRZTKHg9UHb5YvXZzqOnfxoxwY5j8
         q1qQ==
X-Forwarded-Encrypted: i=1; AJvYcCUK/Gk1qzIPGO7b6bnOw094Pd3wBulRxGMO71L7eJQL1wZljax0cYy9VglMhEmaBe5gemrbieuBqu7IhWNe@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3Lw707Qj7soSPM7UFwcpVUU/1xJyv6QoIV6wY4ul7jNJ1UseP
	RFfPrTtKUbxpkA/ks4K5JVPsqOtqnCQacrgvNccgMCSZxDUJJKa5tIxcrLrbItI67ndpU4i4TfU
	0EbnrbF1EF7mJDubpyZhCbyfzruZK0cw=
X-Gm-Gg: ASbGncvJg+Coa4OrJUurTS6/VJ3fCR7hL/dgOpeGKduPnaEdkGis8KhyiMTQNPS83HD
	WsJI9R9c39uQ/PP/kKmSbDxrKYE6pSFbyQrfpEQbpzlnE0j/PpZErbwOS72oThJLM/Bi9LWWqFW
	93kNVAInIXvNsNo0dF9S4wn+9mryaPwEEfif9GbViApyAaAYGz1br9DhNBi9BLnHYCnSSpngyIN
	u8S3K4=
X-Google-Smtp-Source: AGHT+IH8YyamMo41CqZOAsZXvLRklewFieGI+jzkSn0u83bCFBhp/PBUFTUFPwjJHhSsq1td16btG6s7HMLqe72oVR8=
X-Received: by 2002:a17:906:f597:b0:ad8:9257:573d with SMTP id
 a640c23a62f3a-af61b6e0ff8mr699710266b.24.1753554481028; Sat, 26 Jul 2025
 11:28:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250721203821.7812-1-antonio@mandelbit.com> <542b0862-7f66-47ef-9ced-c66719842710@mandelbit.com>
In-Reply-To: <542b0862-7f66-47ef-9ced-c66719842710@mandelbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 26 Jul 2025 20:27:49 +0200
X-Gm-Features: Ac12FXypIat6J0U0bJY9i-wK-q8ptBWw4_qvbSoOM3Um-RWSSg3oCjzgnk4k5wc
Message-ID: <CAOQ4uxiEBxFL1qD4p70UxjB67j9y8RX2r74LX5wDZ5aDDDZirw@mail.gmail.com>
Subject: Re: [PATCH] ovl: properly print correct variable
To: Antonio Quartulli <antonio@mandelbit.com>
Cc: NeilBrown <neil@brown.name>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2025 at 10:33=E2=80=AFAM Antonio Quartulli
<antonio@mandelbit.com> wrote:
>
> Hi,
>
> On 21/07/2025 22:38, Antonio Quartulli wrote:
> > In case of ovl_lookup_temp() failure, we currently print `err`
> > which is actually not initialized at all.
> >
> > Instead, properly print PTR_ERR(whiteout) which is where the
> > actual error really is.
> >
> > Address-Coverity-ID: 1647983 ("Uninitialized variables  (UNINIT)")
> > Fixes: 8afa0a7367138 ("ovl: narrow locking in ovl_whiteout()")
> > Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
> > ---
> >   fs/overlayfs/dir.c | 5 +++--
> >   1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index 30619777f0f6..70b8687dc45e 100644
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -117,8 +117,9 @@ static struct dentry *ovl_whiteout(struct ovl_fs *o=
fs)
> >               if (!IS_ERR(whiteout))
> >                       return whiteout;
> >               if (PTR_ERR(whiteout) !=3D -EMLINK) {
> > -                     pr_warn("Failed to link whiteout - disabling whit=
eout inode sharing(nlink=3D%u, err=3D%i)\n",
> > -                             ofs->whiteout->d_inode->i_nlink, err);
> > +                     pr_warn("Failed to link whiteout - disabling whit=
eout inode sharing(nlink=3D%u, err=3D%lu)\n",
>
> while re-reading this patch, I realized that the format string for
> PTR_ERR(..) was supposed to be %ld, not %lu...
>
> Sorry about that :(

No worries, but its not %ld either. the error is an int.

>
> Neil should I send yet another patch or maybe this can be sneaked into
> another change you are about to send?

Please test this fix suggested by Neil and send a patch to Christian.

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -116,10 +116,10 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs=
)
                inode_unlock(wdir);
                if (!IS_ERR(whiteout))
                        return whiteout;
-               if (PTR_ERR(whiteout) !=3D -EMLINK) {
-                       pr_warn("Failed to link whiteout - disabling
whiteout inode sharing(nlink=3D%u, err=3D%lu)\n",
-                               ofs->whiteout->d_inode->i_nlink,
-                               PTR_ERR(whiteout));
+               err =3D PTR_ERR(whiteout);
+               if (err !=3D -EMLINK) {
+                       pr_warn("Failed to link whiteout - disabling
whiteout inode sharing(nlink=3D%u, err=3D%i)\n",
+                               ofs->whiteout->d_inode->i_nlink, err);
                        ofs->no_shared_whiteout =3D true;
                }
        }

Thanks,
Amir.
