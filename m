Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B9A1FF7C4
	for <linux-unionfs@vger.kernel.org>; Fri, 18 Oct 2024 09:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729244545; cv=none; b=LQd3tcPDDwKyczd4IRS6MiQveM/rzXnro/7ZJM90XAjy5asU/LXNlxtDHWgheUNryN2Q9hmGqWoqU6e0DAuhkLL2NlCfmqVvSiXqaFIZXWA+3eBhbCNo8rHMEfDdFSkoPnFjSKTS31hrRmBJMbqyvqzpge5PcsR2994g1vHfsPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729244545; c=relaxed/simple;
	bh=++04TeDcGdV/Nw/ZsuVZzSKTSLg/T0y3AazsWTk66u0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XmB1MNTN2z5wMOa97Ri5pik28uVPZkCVWO3WR/OfMj56HiFqyI8GDcxjC3MquBGnA6wgb14fZg3g3dGr+dE5emLss/cVDpPLzJWDVXRMf5DAburDYROyOQLx//5fGPqUlzFlXKMtMsG8F4dnidWLEHe0ZHwJYWmY/66lakothf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=WdKVcvuO; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="WdKVcvuO"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9a0f198d38so264545066b.1
        for <linux-unionfs@vger.kernel.org>; Fri, 18 Oct 2024 02:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1729244541; x=1729849341; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sw9AwTwe/lSdKCrzY4oAj5Aeo7yDRO1/177hW5mT5co=;
        b=WdKVcvuOh2oiZJ6mmKV06VOVVLDz9og5Yl89KfC2ENii094+etGrnmjI/9i8e6+Dvi
         JIQH/4JvWA7fDFCyZtGMQJLEskCyYN2idN9wC0S/FwnGJcUrYilamNiA6Oqw3ataxriy
         PA4KlpECwfAvamCvr20Xg1WsDrueWlqkP6Bhs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729244541; x=1729849341;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sw9AwTwe/lSdKCrzY4oAj5Aeo7yDRO1/177hW5mT5co=;
        b=YLdawYMqIROt2Z/ZWxA68dtfaByE3NxN16849phS12IjZgs/QyWEN5wGtV/BMrDxkW
         7ZPO2buIDe1QnTxUlugwDMDsY6t7CLPs7m3iiWUVN0SjKCLWA5VtE/v0e581dZSRDSoI
         fQS317oT5dN6Pje5m85eDwq7LJg2CH8Roik3Tjlmo/pP6vK7uokUNsDFzlQvIiitV7Rr
         P+4Jp+Mmc3ETx5xOBAwg2ZGaEo6fx8hTa+B8zMDJUWseY7BwU/Hnu4JMMJOYlIHsreYu
         eToODdTiXU6Kc2GNRnGr3Cz8RRBEZLXsq4vzScUfyjJwDf0MBR3ZYFtaYfTFHMzVZVKn
         TjTA==
X-Forwarded-Encrypted: i=1; AJvYcCUFJuALjLrHo+ca3swiL/udzXgfFNQCil2ry26tSBnV/XGMBYsqEP780ADPNTsAt3RLBgQ1sCSITo7iwKqH@vger.kernel.org
X-Gm-Message-State: AOJu0YzAN3+HCtzVTVvHsI4o+4/ik9dvXUE677t+n2k81ipjGW8sSZrB
	9pBAyvFeKYeLHSn5v+y7t8pOlf0G7JXEAp549JMzCsZhVkpzZjYsToKNwVli45scHOh1Gk8oNch
	1EQBPCIu3L+lxUfdtCiT/REOXWCPRe+rwm2l3zZXp0VtBUKmv
X-Google-Smtp-Source: AGHT+IEj9l4mWj/yLjIBXQx+ZfOpGTTtvj/jHJnSTnhPIN9nEREN5Bma9w2X4rE9TorROLNxJC3MjApWWvq3RTB6da4=
X-Received: by 2002:a17:906:6a1e:b0:a9a:1115:486e with SMTP id
 a640c23a62f3a-a9a69c6a83emr150343366b.45.1729244541139; Fri, 18 Oct 2024
 02:42:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241014-work-overlayfs-v3-0-32b3fed1286e@kernel.org> <20241014-work-overlayfs-v3-2-32b3fed1286e@kernel.org>
In-Reply-To: <20241014-work-overlayfs-v3-2-32b3fed1286e@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Oct 2024 11:42:09 +0200
Message-ID: <CAJfpegvqDPqVMfUkTxVSE580QF5mqOeorH7fT+zUoZGqqZ3TNA@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] ovl: specify layers via file descriptors
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Oct 2024 at 11:41, Christian Brauner <brauner@kernel.org> wrote:

> +static int ovl_parse_layer(struct fs_context *fc, struct fs_parameter *param,
> +                          enum ovl_opt layer)
> +{
> +       struct path layer_path __free(path_put) = {};
> +       int err = 0;
> +
> +       switch (param->type) {
> +       case fs_value_is_string:
> +               err = ovl_kern_path(param->string, &layer_path, layer);
> +               if (err)
> +                       return err;

What guarantees, that layer_path will not be stored to in the error case?

Common sense, yes.  But I'm sure there are hundreds of cases where
it's not the case, despite common sense.

Can static checkers deal with this?

Thanks,
Miklos
