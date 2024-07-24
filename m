Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96B413A41D
	for <linux-unionfs@vger.kernel.org>; Wed, 24 Jul 2024 21:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721858128; cv=none; b=kdzF7yEhGcvM0eAKDI+z1m1VlqnlG1OV3TIE6TQDQi5PNsc6jYW7xTZTgl0iYHMKmNdJ0bmhagBoeZ5SxbqQtjIxu3yIb0VW/QaXvo4Lpg5PfL/Pk7SMyzOHY/imVUDAM2ZmntWIeM46IG9ItNfvcJYZpTnKwfPSLI6y6xeKW4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721858128; c=relaxed/simple;
	bh=+mMd8KWa1udV1Q0WOLgzdraq2NYFnE9apCBA8B0M7J0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tq/THiHWo6rdgEQAPoV6y7U1ydW5d8ojNfEZLo8907VRXEJKJEOr2vEvib7ZILznUwen2ZAhK5+dWBDY897SuiqXxQSlCpEmB/e5zHnPxTsJ7KXm9myIB3BoF2q0KIAQX1UDv+4n4Qg7U18MSYOLQ7rHYibFafiBufwhJcwX8A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=E6olU3Bz; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="E6olU3Bz"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-65f880c56b1so2600827b3.3
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Jul 2024 14:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1721858125; x=1722462925; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sX2S+wkSh9PXj1mrFurJA9PykaHp11nkFTGDDdb5ssA=;
        b=E6olU3BzexqV/EbGRySbKn/ll3xfNW8Bz4Nyrxod+GrBNwyNiV9Gdi2hFl5YS7zrXf
         O21SL1u7PFhkYGexslfYNNtHWBg+1fyE1hsgdSvzySBJtDOy0iC1DQE3xhNFRhjWbQFI
         hYllL6ZL6fX/bzkHQH2ITtIg9A5EP/23MKDjZOe5PiyC+WBPc+9qJYDPY1b7ZXaDuwOj
         9V4dC0eb9xzCKpDZ1EtafvvIhzvZ+QN77D0rSyeOjCCfzVwZ7J0M6pQudzYhPrqwf7bz
         lGK3KZoSwKoPAYE5BwlgBrcXHPEDTWkcHeSMTnzpO0jVdu2gtpCZj2s1QT0vbLq+DqzK
         nreA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721858125; x=1722462925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sX2S+wkSh9PXj1mrFurJA9PykaHp11nkFTGDDdb5ssA=;
        b=iPuGpGOq6GDUlvhqrtqg+jbEiSe9Jre6AsuWW/EhFHFesHI1gMQ0SEZVkqGTiYLvQr
         CeQdyLiCJUT6VbiYJwxtpoW2sqVzSR85moXiDNiyOae0n7cRaLwOzaXwZdepYd8Rs48i
         T7Xx97bElaZ0sxGvqbZRTzMZ70RCO1T5MSR0Y2ggiPPDwcAgX+6dycaE/9PfLDe+4kjH
         hTNslkJb7zZypnxEZr9OXOO7yPYk2U4eveTJ84/tp1RuDFWxtNaxskE8mnjYA1p+ZSbm
         U4MZgfjJ5+iSXZj14AyzgwUds6VRfNnpZHs6rwU4KPsKTSaD7csBdKlASzdqgIk4rmum
         8p9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVYhdZXdQKmXg7RkMNgTc+A6M0CtlyqKdwByIZ9Jjec09gXLDebQ3JGEOa5KAxruswNFjC2z71AWaGgGV9yQiJro284eyeB1bpvxypnGg==
X-Gm-Message-State: AOJu0YwpFDyqoGXPtdsTjKMIoKQRkn1Kt6V7aXmK6WnDAZOkgZ9l7Q83
	zVAL8URnVajyrtUMbKjxKMKUeFo8cGotrueXV2DgwIPODS2qZ8Qe6iFnrvD3pcC40gQIjrDl5bT
	eSVmP8vhwHDO2w2YjGL7xdIOAnEsrrrErrW5l
X-Google-Smtp-Source: AGHT+IEvK2qDe3JpupN8A/TtWU8g9/xrVml3rY6g5rMwfVak/BD44/4JmQdOkWDHisL63uxy63dZ/n2jLT0o+6TyI2Y=
X-Received: by 2002:a81:c24f:0:b0:665:657d:9847 with SMTP id
 00721157ae682-675113b33a1mr8994327b3.13.1721858125677; Wed, 24 Jul 2024
 14:55:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724020659.120353-1-xukuohai@huaweicloud.com> <26bb0c7b-e241-4239-8933-349115f3afdb@schaufler-ca.com>
In-Reply-To: <26bb0c7b-e241-4239-8933-349115f3afdb@schaufler-ca.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 24 Jul 2024 17:55:14 -0400
Message-ID: <CAHC9VhTfqhWe9g5Tfzqn2e2S8U3JrCJ2zjjgKKJF0La+ehwAaQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] Refactor return value of two lsm hooks
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Xu Kuohai <xukuohai@huaweicloud.com>, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-integrity@vger.kernel.org, "Serge E . Hallyn" <serge@hallyn.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, James Morris <jmorris@namei.org>, 
	Mimi Zohar <zohar@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Eric Snowberg <eric.snowberg@oracle.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2024 at 4:36=E2=80=AFPM Casey Schaufler <casey@schaufler-ca=
.com> wrote:
> On 7/23/2024 7:06 PM, Xu Kuohai wrote:
> > From: Xu Kuohai <xukuohai@huawei.com>
> >
> > The BPF LSM program may cause a kernel panic if it returns an
> > unexpected value, such as a positive value on the hook
> > file_alloc_security.
> >
> > To fix it, series [1] refactored the LSM hook return values and
> > added BPF return value checks.
> >
> > [1] used two methods to refactor hook return values:
> >
> > - converting positive return value to negative error code
> >
> > - adding additional output parameter to store odd return values
> >
> > Based on discussion in [1], only two hooks refactored with the
> > second method may be acceptable. Since the second method requires
> > extra work on BPF side to ensure that the output parameter is
> > set properly, the extra work does not seem worthwhile for just
> > two hooks. So this series includes only the two patches refactored
> > with the first method.
> >
> > Changes to [1]:
> > - Drop unnecessary patches
> > - Rebase
> > - Remove redundant comments in the inode_copy_up_xattr patch
> >
> > [1] https://lore.kernel.org/bpf/20240711111908.3817636-1-xukuohai@huawe=
icloud.com
> >     https://lore.kernel.org/bpf/20240711113828.3818398-1-xukuohai@huawe=
icloud.com
> >
> > Xu Kuohai (2):
> >   lsm: Refactor return value of LSM hook vm_enough_memory
> >   lsm: Refactor return value of LSM hook inode_copy_up_xattr
>
> For the series:
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

Looks good to me too.  I'm going to merge this into lsm/dev-staging
for testing with the expectation that I'll move them over to lsm/dev
once the merge window closes.

Thanks!

--=20
paul-moore.com
