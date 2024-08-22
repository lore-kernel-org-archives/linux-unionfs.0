Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF87116DEAC
	for <linux-unionfs@vger.kernel.org>; Thu, 22 Aug 2024 08:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315189; cv=none; b=byqe4i9XWSxA1t5VF2PjZWzq8hFovs6XXOLljJxbiUhI6pzoz6HowZuX8Uc5aLK1fIF7lApsEE9FpJ3zawoXZq1zIquPFwBLcshr1/Bv6RzveeO+/xhjyJHdTnfkdEgBOMmTMMoSFhB0FPJYIGRe95q+l2SFUvsCFtoGRc9R59s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315189; c=relaxed/simple;
	bh=uulRlCS5U/ZWFU+NiU8AQ4kmJJlakyTPxZ8IWIRFdfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ht2rHLcbyK0w9Z6v68FeXnLdLqx30RyV5VXq6/0O5ASwwVHKU5Mo0vjIB/jMl30y2Dwfy2/qPxW1WhNp4IAa99vfiElCCgCAhoScz8MGBSzjqEECS9hbb1FQ+wIlktPn1N5iLdom+X233VWPMUCb5aSkPlLHERACT5Jb6LQdZXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=SE4VuLCG; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="SE4VuLCG"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e115c8aa51fso570275276.1
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Aug 2024 01:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1724315187; x=1724919987; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cwsQfABTNmfVMxMhs8Cv7JuAupm/w/QRfZU+NP8//FI=;
        b=SE4VuLCG3vYSGK3AFufI+ZdpgA+dyLdut48qYD0EnWNqq7Mx1TIbAbflb7urZAdt52
         AUkVAAfIZKOTHUOnRRUmFOvKXMdQll+dUyoRs8t+6wAfS4mNWhXCtr5xxCArzfi8VOeW
         xjeR3chfAYktnK7MiuDF2gk+Basw3UTJK6PN8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724315187; x=1724919987;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cwsQfABTNmfVMxMhs8Cv7JuAupm/w/QRfZU+NP8//FI=;
        b=gJ2Q6GJd/KNFfxwYeon4U7w70ovXIM7OJSUqGCbNQOwRr+GYcC3jV1HJn59T9FvyBR
         u4+m9pC2At3bEZ7PHfqlQZ0xp9qDtuE9y3hRvm3S7FW9XAEX4X02noBWXm8IEgooZR1+
         UcNKX79wjjOBIHiah6D803qVNs2yqVrdirXvmTcE0E+oH/CD/gvzcibfB2rs6tPHX61P
         w/OtMgZA+ud4m+rBoe8Swpk4AXHKF44yslsiYL3NFFLHGQqgymmzgxkVr/a+3yNJ5eVK
         6i/p2htH6HZ+g6xLq9yCh6OjRC49BPga732Ua6qR+X2xb3N56eOHAaChlOICqPiqljX1
         olvw==
X-Forwarded-Encrypted: i=1; AJvYcCWNIRlyUKkosch+XsNhMTGhl8YUOqa/xQE+0eD58EA26NaJ1c/ryRgz3T29smtZLex3ZNpT7qWPAU1+PQJw@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu3P7oCxa5cNemYGN+hnc5+6v0OFMtvcYbnYvYW//utUMxFtZb
	3d3mXEVk+AUU1FvLLvxtLy1r0XpojVBcOzN6tSp8jjciyiwR8i4TVCTFr3Rm77brMoJ3e3L7XH5
	d77erKgD1CYyXKzUR3UvgpG1OhXVLpi0Qwy01RA==
X-Google-Smtp-Source: AGHT+IEGeV6ssKuZdYjsNaigszO4+1jA+aSMkpYZo0GKMQzwFCX6dopqvMlxWyEPuvgeOxSlwsVXnIdaylF3iUFAlg0=
X-Received: by 2002:a05:6902:1209:b0:e13:65c9:e994 with SMTP id
 3f1490d57ef6-e16664a4d7emr6455861276.41.1724315186841; Thu, 22 Aug 2024
 01:26:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822012523.141846-1-vinicius.gomes@intel.com> <20240822012523.141846-6-vinicius.gomes@intel.com>
In-Reply-To: <20240822012523.141846-6-vinicius.gomes@intel.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Aug 2024 10:26:14 +0200
Message-ID: <CAJfpegtko6VtNpshGUzZixE0jqecwQR91xT=Q7W5sf6HPGVPeQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/16] overlayfs: Use ovl_override_creds_light()/revert_creds_light()
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: brauner@kernel.org, amir73il@gmail.com, hu1.chen@intel.com, 
	malini.bhandaru@intel.com, tim.c.chen@intel.com, mikko.ylinen@intel.com, 
	lizhen.you@intel.com, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 22 Aug 2024 at 03:25, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Convert to use ovl_override_creds_light()/revert_creds_light(), these
> functions assume that the critical section won't modify the usage
> counter of the credentials in question.
>
> In most overlayfs instances, the credentials lifetime is the duration

Why most instances?  AFAICS the creds have the same lifetime as the
overlayfs superblock.

Thanks,
Miklos
