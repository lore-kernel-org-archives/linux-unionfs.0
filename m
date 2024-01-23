Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBAB59B69
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 09:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706003671; cv=none; b=taYHyqCpAg6aDzmfSDcesP1sDuCnOphwxfiVcVvtsHz/eSzcjj53MwFwURE71dfsSdVpnx+bO578H9DC+kfFksxvyIzveFNFCg42kEPxG4Zgc/76eCF8qwInNiXXA8jpfUzRZI3C1pp2QnGIOA2JfNI4C0TblIyx+vUw5GAx1no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706003671; c=relaxed/simple;
	bh=chz2eggifcQKHG9cZl6ApdLW9wfeFanky4LYm0URNIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=svW4rJDfM0aX18cRtAzIoL5bDK5PkTjNplPFxy5ownXAsycOHstoHh84Q+XqDP1tvYF6jrhdiuTlRd87SoyXQWF9einvM1yv1XdidLFfRDWFM4KtsCxpJ5SRGyj5SkM1NoCNg2OEjTS7U2eoitWB7+TzmGbrMstXGrpXoW/lF7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=kn1avya3; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="kn1avya3"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-55790581457so5512121a12.3
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 01:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1706003666; x=1706608466; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mTEzAsuULynvSAR0Fjhab1wfbmKNhg3+8xr7RL7CSw0=;
        b=kn1avya30EWRt2lsRyWgM1jjSZOW4IYU8RFcUzg0iKpOqUVISmp0IwpHUen4cAQ4Fp
         XugaQWtGVouSyysQPY6MZTKjLvNDE67GJNUUP/PSunCcsUqoq3nixOkWC2tOnSzpNP46
         acg9JND5R2SqdVeBbaWGoU0U7meITg4PAR6BY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706003666; x=1706608466;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mTEzAsuULynvSAR0Fjhab1wfbmKNhg3+8xr7RL7CSw0=;
        b=j7eTxPHzRFGD1Lsq/l4SvAsKOgRQZerPpqdNRLmBsEzswapUQhocyX6sq1VRtcO30X
         m0DaZePXnLbI5BDfKnLKNmQXGaf/WETrHkORJpKvisribIlD18WadFT/DXqaVUeYMzrG
         yvN49ef8deyk4Oi4evwE/SL3X7/GSDlvpazIhWTw8/gR5fzv57Hr6raTyiQO6PaMJW0/
         myF6Lisqfhx6pfAUgzFGXZW7BLO14Cddu33DVIGJFCY9Hu92QfcjptwYXgc0Nbxdniq0
         CiFT/JWcy71v9ySUn+hJ6zKDgyAvZFqc99xqDLgqnW6mCJYsIhz6mv6HFoAgKUrdYsjm
         BUKA==
X-Gm-Message-State: AOJu0Ywe8v5jkxhHOZBua/jtl9a9tgtLJTgEY2zqKGqUFNQhL0LT0GOo
	JuShSXcNX/AxTnCdEG1jmyT5CfPdYclKXIolSKNYEmk544N6L9AM9ydUJaD/Hs24KcoYkuVYa4P
	aVB+XbEubrYNIj2NcrRidrrizCYDT4nx6q/mXYA==
X-Google-Smtp-Source: AGHT+IGeTZTS9AMoJ1cvIm4uwJhPGnAYGatbs29qhd9f4g5WiQeA6KtXZnmRn3PC9mn7kw22XXQOPFU9PivZogzBwzQ=
X-Received: by 2002:a17:907:848:b0:a30:d1a4:eeda with SMTP id
 ww8-20020a170907084800b00a30d1a4eedamr272169ejb.150.1706003666103; Tue, 23
 Jan 2024 01:54:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240122195100.452360-1-amir73il@gmail.com>
In-Reply-To: <20240122195100.452360-1-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Jan 2024 10:54:14 +0100
Message-ID: <CAJfpegtbM_tGH0OfmP08qrVPp5iDDJBeppAwsCb_m=+kS7Hbpg@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: mark xwhiteouts directory with overlay.opaque='x'
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 22 Jan 2024 at 20:51, Amir Goldstein <amir73il@gmail.com> wrote:

> +void ovl_layer_set_xwhiteouts(struct ovl_fs *ofs,
> +                             const struct ovl_layer *layer)
> +{
> +       if (layer->has_xwhiteouts)
> +               return;
> +
> +       /* Write once to read-mostly layer properties */
> +       ((struct ovl_layer *)layer)->has_xwhiteouts = true;

The cast is wrong.  After this change *ofs->layers is no longer const,
so it should not be marked as such.

Looks good otherwise.

Thanks,
Miklos
