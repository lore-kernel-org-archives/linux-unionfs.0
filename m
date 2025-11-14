Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EAC50276
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 12:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763122557; cv=none; b=SGSNL6A71lpG8XTTLvayhDEWEa+pNBmVW2TdbSaXv/lSpF7v2GD29lb9IT9Ngq51if6QvOSiJugEfKVvIHkmZthbRblkYW4cMBXTBg2BUtWmInxF6BLZ0KtDoi9dwHOp6ELJSoA0gHhQlOSlVYkZcGzXaq+P55YcZ7qVq1K2eec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763122557; c=relaxed/simple;
	bh=47PNF5RVuJ3c8BHjRUvOBQJmrdIH6tNxp/wXGr1F1mY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mdyx6ZpKXmzI48QmR+hPo5bx25qxwUT/dGDiY+SHEREaX9zGcizseSjerODXjn2AWEBToe0pS0auNVd4zxC3NmdFMuLjbMaeTayukLhyHdMH3sfFFYHm7/LfHaeShsX7rx4phpLUP4+TVp62jm/J6tDnD58bmcmIi1eG/ThYPYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SneHrKKF; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SneHrKKF"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-641977dc00fso2822746a12.1
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 04:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763122554; x=1763727354; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7PXXqBWzJqn3zGwsEpNyZu8WMfzixBgnRapPRgsdvM=;
        b=SneHrKKFVnDueYScYsWsC+x+Eo1saV/U+y0dIYM04JxQ+1XCaHB1m5/KL/EoIbRQc6
         slsTLgqauDk1JqCc9F7NUHGHnvlAlEf8hujjmx9vxveZvG73uy1del5FxWw3v03t/asZ
         3vH/QL0ERlnBhF7NtugZ4jkc7nEJ9HX3gHIZdBI8oMJ76ZZcumRW5W+klcE/2dcDpHOR
         WOTGlDWPRLcnZsnPPH9J5S46CJKyxiRkqjtwp/vChp314BIOEPcCuDc1KPjos83u/ukZ
         mSpszbrz3VXCjVG0X0+cEZA9Lrad6stIqVCZAx9BOSfE1oW1IpRqniG+tqfSeznS3tmI
         DaoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763122554; x=1763727354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S7PXXqBWzJqn3zGwsEpNyZu8WMfzixBgnRapPRgsdvM=;
        b=aVgofK/JJn6FqT30/vk8S/ohd3WubDijJCFXfJQqBHW8CwMsE37pKU+u7a1ZoUVXKj
         2Pif2OdCO9+2nYKS1mdAkQXOZslOCtuf3tIV4Bcxs+hKKIKA3sQnXJYycw2KuqBsQlt1
         6TfFHkEa31bPXcBcOq5JVaJ1IAO12mHl7nz6Qt5U/snW0ZLNBxEjlviZqPr9BQ3yI/fZ
         LFRAZ5eQJGX5C2VsiPRobkVAbHB4S61phsyzti6KoKGIEaryhdC2br9UBhqHeZ0RLRlN
         dbkPl6DxWcLJMJCL3CxbJPwoG3qUNPz/VcfFYh9soWzU3NUwe1wuWg2NGqLqm1k2Hqdt
         Hybw==
X-Forwarded-Encrypted: i=1; AJvYcCUjb/sFWDMiVUZRPH6n4Q+5a83YrsfnOYuxGIHQS+FGKoAm8Hbx2T+73It/aT7ROR5hDOA3NwVZ191wqQ8V@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6VAsaUJT0bgCrGYaNmKGa4kSDJr3pTshSx14Xt0NtQoaAvuGH
	T55DxA3k1ADahWh4ane0bJO1z0U353dYNIvfkgmE6WIlJesieM37WW4jFPQqsbzIk2MTibKDzhB
	THkq5LsepqCcEy/8v12l+u2BzwonH4U0=
X-Gm-Gg: ASbGncufYZroDD8ZHTMsRtzE9m+FEkXquzA9jQM+NCE/Y9G6aA7YVY0GPB1jmgxwe1p
	BsHutGw8QonLV/OfJbECnsJOgURtnVnYcripY63AFiqTY52BKCCIVJAmFXZ2zJ3vZv09v1886qc
	2DYk5XFB5alu6Xj+4ZZ2pZeXqs3+h7PHTyoI9bEClkurXMg8dVoXXDWEDehtSjtd3H9LxEId2kV
	Bgg6pHhStkyI0MOFPb0EVQpVWzkV09ikIS5bjLzNyBHGurIaRr+THY49Fm+k3Rcz7X1we5k7ClY
	YcmKMU8wF75o8d20U7mi6YUiCLmiaA==
X-Google-Smtp-Source: AGHT+IGzFauNutjrU2V3aB20Ao5tLDc8f5yniDQzWBbdBv99NzPZX+H4OgBmFD4r8eLpzR3oWyiB94uGg8RieaeaJAM=
X-Received: by 2002:a05:6402:2115:b0:640:ef03:82c9 with SMTP id
 4fb4d7f45d1cf-64350e1fa2cmr2264080a12.11.1763122553522; Fri, 14 Nov 2025
 04:15:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114-work-ovl-cred-guard-prepare-v1-0-4fc1208afa3d@kernel.org>
In-Reply-To: <20251114-work-ovl-cred-guard-prepare-v1-0-4fc1208afa3d@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 14 Nov 2025 13:15:41 +0100
X-Gm-Features: AWmQ_bnStc9yabet7bIV01pOuNjHccizHxm665gq1pv8xM9J20chqME7d-5dp2s
Message-ID: <CAOQ4uxi5OntG9b7d9DZY2cS4xMtXNp7x-gUWespxgubf8UBNJQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] ovl: convert creation credential override to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 11:15=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> Hey,
>
> This is on top of the overlayfs cleanup guard work I already sent out.
> This cleans up the creation specific credential override.
>
> The current code to override credentials for creation operations is
> pretty difficult to understand as we override the credentials twice:
>
> (1) override with the mounter's credentials
> (2) copy the mounts credentials and override the fs{g,u}id with the inode=
 {u,g}id
>
> And then we elide the revert_creds() because it would be an idempotent
> revert. That elision doesn't buy us anything anymore though because it's
> all reference count less anyway.
>
> The fact that this is done in a function and that the revert is
> happening in the original override makes this a lot to grasp.
>
> By introducing a cleanup guard for the creation case we can make this a
> lot easier to understand and extremely visually prevalent:
>
> with_ovl_creds(dentry->d_sb) {
>         scoped_class(prepare_creds_ovl, cred, dentry, inode, mode) {
>                 if (IS_ERR(cred))
>                         return PTR_ERR(cred);
>
>                 ovl_path_upper(dentry->d_parent, &realparentpath);
>
>                 /* more stuff you want to do */
> }
>
> I think this is a big improvement over what we have now.
>

I agree!

This bonus cleanup looks very good and helps with hairy parts of the
ovl code.

Overall, apart from the reuse of ovl_revert_creds() helper name,
I had only minor comments about suggestions for
CLASS name and helpers, take it or leave it.

Personally, I think I can leave with the minor confusion of the
static do_ovl_ helpers vs. ovl_do_ helpers, so this one is up to Miklos
to stand ground or not.

After rename of ovl_revert_creds(),
Feel free to add to this series as well:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

This series also passed the ovl sanity tests.

Thanks!
Amir.
