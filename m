Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981542797AF;
	Wed, 20 Aug 2025 09:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755682400; cv=none; b=BcVXTqIlcxqZUWRIiLbY00Z8cizjsuJpJ7zSeVzu4r5BdbiUImvwkf2/0VeJbIzbQxeRlilCbJ20SG9ASG+HtoC+HDAqO8z0pJhnnZuZSIpxfPhCp7xspj3w1iuyukk3ZOij+hyZJjyzNWFTINQlzt+UKRcoeYmt70vwl71j7vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755682400; c=relaxed/simple;
	bh=RBChi2DiMntzcyYhqGItraXPe/ev1K56OAUIaEaLbp4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dM+wmB79lo6ds6y+Ge8/9e2P0H1ikc1tQup7U1HjhSWcx9KaDq70z8O5ZQkfZNASqelM6s2k1gp2S2SX22SlmcluieRZ9CluwKvAUFUXhN+RWLb0FdzmWw1XDMYlkjc7N6vkKa2K2y4nRoZoBSCZlu9t4FsGBlg+ul58LUePgyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VC+/SiDU; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VC+/SiDU"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61aa702c9ebso58366a12.3;
        Wed, 20 Aug 2025 02:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755682396; x=1756287196; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nC/ErX59hxj/M9+ZZ9xBj0Dkel5DuFBTrE0bcyg4loQ=;
        b=VC+/SiDUU1Xf7Y7tMrwihzCsZiqgQ+shpoDlfuQ23dcJ5xD+v5S9ullX/Xt2h0oT/Y
         kQS/FSvYKZ83t8CT8dWYrV9NFIhPzpvBBVXsp3yuJYwCWXYSNG9TksHFR59fQxE/JmDJ
         xoNOYbQ7kywYVvuhj54ZEq0IPZC24W4FLLv3Daz03WsqyFqVOhnXqQFK/q9dd7tAmkcA
         SNF/FeCWkGl77a7xZLIbm983JJi0DLH0Z/OtZtZ7sZMVU2KEgt75gWvyCZkDTHwaBJCo
         L4WCaaJn9zi1TbBWhrYiEI+EaqWlwQbOB8Z3apMojAyqOKVZePUxT9v2RLouWZvPa2J7
         HgFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755682396; x=1756287196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nC/ErX59hxj/M9+ZZ9xBj0Dkel5DuFBTrE0bcyg4loQ=;
        b=eNe9DDiQISW0iZHr6MFUg3NU91O0qKlr0DKqv43T/WXy2nBfaDzdaOvtDCIYJTerDb
         Qa9yCOPv5v+D1+7CLqhZdpgMX7ta0Mhx5xWWbOWzHSo4wZ6P8zYt7hl7rr/dA5VUXSjY
         Fs7nPH7UVb0WssoyI8/draLUH2+a+gEuy0sYt3nhFXSSRL1CgR/beO5Q6RAGfS6bmBju
         BhyN/p27Y8jk2wTFp9sRKNHAVVp+fQJ0kvAdEoW1C9tzO/KTgpwzZy49sNGXuu0QaZGX
         n2KF25axNaioQLk+TERNxU5WqemDrgrzOM8yG9ipegAOhjdmpAbZCOeumTyrB1s4IeGg
         H5Yw==
X-Forwarded-Encrypted: i=1; AJvYcCVwlJlaNQEp0YoWG4oApGvJBDPjn1ZxN/a/jugyEqMIj9dbxX6lzEh1gTGgOGCB4G44U4RsNPfe/kyMFWM=@vger.kernel.org, AJvYcCXRSFYzTNmGgPdNfg2ndlkgHU1jH+SyUJteUVJ21sk4FEnS9e6Rz9MIOPvyTZGYjSKDHSVdoIPCZ4ZmqO53Hw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzIg+NKpozq2dSuLW/qVVeK7bTvKaZxWURXYw2d1HPTjxhVRDsU
	fptRm5asJdN7tx/7kqj9xxYiUst+gwHvmefK97LrNFwTwWR34T64dgAN6MG7TnBSdMfdgt8heaU
	oumTTq2ZUt2WdG5DAbJqLjVVonLFZuac=
X-Gm-Gg: ASbGnctoUdIZBp/lf8QEM44K6hI2nVIgrHBE5fry1BqpEW/Xba5KUeXEVFoJq8e51JL
	xHtCK/qqG1bG4/PGjFFk5mqrvZz8Led9NzJ3hUzNLWq0ybyD5VuHeS4jhTrvwucd2udbJ7FISng
	z575OKMqr8hTeInbs9/RgONbC7sjaoMy4EB5BpCRa3uKxSdt6cbZ6e6Waip3sVWFL1GcBhB1H4p
	JCzkQc=
X-Google-Smtp-Source: AGHT+IEb8/Nho88DGGiiw1ulj4AneyBUzB3DShyiR49gbPNu9RkdQ0RDKyEG2k7cjOcRCKyL5pBS4K4rO3cwUwE3RN8=
X-Received: by 2002:a05:6402:34d1:b0:618:1ccf:5d12 with SMTP id
 4fb4d7f45d1cf-61a96c69776mr1923910a12.0.1755682395661; Wed, 20 Aug 2025
 02:33:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820092848.534-1-huhai@kylinos.cn>
In-Reply-To: <20250820092848.534-1-huhai@kylinos.cn>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 20 Aug 2025 11:33:04 +0200
X-Gm-Features: Ac12FXxDHa82_d8nmLxd2oWup-p4EYB6zzv1ykW2nX8LHFAOae2CfMNixeutPy4
Message-ID: <CAOQ4uxi3YSUsf1SOa9HA+8VFcFe1=5FKjZ-NvYnPaBZK2yOMwA@mail.gmail.com>
Subject: Re: [PATCH] ovl: only assign err on error path
To: huhai <hhtracer@gmail.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, huhai <huhai@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 11:29=E2=80=AFAM huhai <hhtracer@gmail.com> wrote:
>
> In ovl_get_upper(), the result of clone_private_mount() was
> unconditionally assigned to 'err' using PTR_ERR(), even when the
> returned 'upper_mnt' was valid. This assignment is unnecessary in
> the success path and can be avoided.
>
> Move the 'err =3D PTR_ERR(upper_mnt)' assignment inside the
> IS_ERR(upper_mnt) branch so that 'err' is only set when an
> error actually occurred.
>
> No functional change intended.
>
> Signed-off-by: huhai <huhai@kylinos.cn>
> ---
>  fs/overlayfs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index df85a76597e9..a29ce0bce6a5 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -512,9 +512,9 @@ static int ovl_get_upper(struct super_block *sb, stru=
ct ovl_fs *ofs,
>                 goto out;
>
>         upper_mnt =3D clone_private_mount(upperpath);
> -       err =3D PTR_ERR(upper_mnt);
>         if (IS_ERR(upper_mnt)) {
>                 pr_err("failed to clone upperpath\n");
> +               err =3D PTR_ERR(upper_mnt);
>                 goto out;
>         }
>

NAK.

No good reason to make this change.
To be clear,
"This assignment is unnecessary in the success path and can be avoided"
is not a good enough reason.

Thanks,
Amir.
