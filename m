Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2871154424
	for <linux-unionfs@vger.kernel.org>; Tue, 20 Feb 2024 22:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708469833; cv=none; b=QQJkPBahdh4Ud9Mc3ZdGFqyx7JJrXNyzRg4iL7iU1ju+7OvuXFEGQAGkXNT/07BF/0eFsAWAii9kJdWQpVVfV5Ko+iTD5ZFMaLOQiehdKUwNVbRfqfrrOeNqMZzHF1h3xI6kqsJGfihu/PaJs7+IGOIl5xEO0EcLt4HTvUbryGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708469833; c=relaxed/simple;
	bh=0YoTDIJcncc26mTV5po/0I8NONU1TIZscyHen9QSqfY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D7y4LXElWdDVl6nF9liLkjV50Al4kko5y2KJGScZz1rVYWpo5f2qeANb8JHQ2bjjBL9fbn1jsjIj6eUvc42hmlQfU52fX23ZuaYTAe/IdsRnA0MV3atK5t59R86ULM+M0bJD2pax+wYnHWciiXSlH3Pnh0gqZ73dU60osj+Dr9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=RpAGfWLP; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="RpAGfWLP"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-dc23bf7e5aaso5768091276.0
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Feb 2024 14:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1708469831; x=1709074631; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJd9Z95KHyUDEhlhjVDF9yk1T1M4Mk1fPdy0+yG5dqM=;
        b=RpAGfWLPPDa5nT1skE2IjquSvPCpH4XDjqXhHemyIuLz/hdLFGrOI1tMaygPMyiCVs
         q1vL4So8FLcrldPFKwFwxHFIOlY3Tn9XtYh0dp0OU9mZt1hPj1KBXbigYV7RhBWQ72m3
         /5oWhtMSkEItzPCnERUndzCdoGbwMpLUX4LwXn+8CwqgLtjgehsJeMbx8stcuhe+DiQq
         9DTWoLBnlupgUmDPko6bERx8iVPqd/o3z4lCax8zyHitOjbWF5QwbAOx1z9SvZjJtvoX
         Va9Q7470lI85S94fjTf32AqcWVxq857I6+nq+RDXXdOmVqQUPU2L2VNe4GAXhWQ8FpVE
         RPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708469831; x=1709074631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJd9Z95KHyUDEhlhjVDF9yk1T1M4Mk1fPdy0+yG5dqM=;
        b=QMUm6wrnFPxF+d38Iudfv5K1DXSZWbsxBDDtAAT2V/Dq+yJPNQt7cxJYEbuIgttQWc
         uagJ5ER2+g7E5dhaguh7Y9L3FPByjFSqmHD7yS9Z1TVQDp+FUtVRpdHWpbMBrYTGfjcw
         bBIFBmjilePg1IxMZwAerBuclA3RTL+7S+If8wjSGTG+7EXkzlQO+NEeunGpxVUZPfYR
         rCfJIuYVUagZwrbAf07RmvhC1c+d8mz5GeP48pAkvBy51s6KejT5sgBPBPJHWVE2eoZa
         YtBTdFFuGRsO7jCV1Th+dEsXxOWIld6MKNde9tMQlC1ahKHnFtDoKtktDf0HPLNsKfmH
         +bZw==
X-Forwarded-Encrypted: i=1; AJvYcCUJ4mYY4lyMW5d5sPlzVK/0hx+QXQ8J0WSZCKw4vR1mqDjSY7gbvdI6V+YbyFV1R8QjutW6+oWX7YZRDtA2aHao/nkJB/uSc0W5XMjtzQ==
X-Gm-Message-State: AOJu0YyXnICwB38ETMTpQV9a4omA85fuVQs4ueYfw5XoTmtmXBHH1ErH
	EgGFDPAF/SAphzS4XDuXjQz7miJk8ivKx+kTlMEx+MvhWIGzfa9envs61N1B2jibxRdmT7bbxtw
	2SsdgxyGoEcvARPu3DiJjqDbugKPqaKEPQTk5
X-Google-Smtp-Source: AGHT+IFHQeTBpph6bd5Wo+fr48nsOpy94ua8Yw9g49gmhGuBFZaV/bAGvI69UADzVdw79h3Ed3LE/pbEkd6/IuyV7L0=
X-Received: by 2002:a25:ef0d:0:b0:dcd:ad52:6927 with SMTP id
 g13-20020a25ef0d000000b00dcdad526927mr16249258ybd.11.1708469831057; Tue, 20
 Feb 2024 14:57:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240205182506.3569743-1-stefanb@linux.ibm.com> <20240205182506.3569743-3-stefanb@linux.ibm.com>
In-Reply-To: <20240205182506.3569743-3-stefanb@linux.ibm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 20 Feb 2024 17:57:00 -0500
Message-ID: <CAHC9VhQeJGjm5VCF84W_u2wRZxHtWPMt_Ku-NqJpXUaA53EtVw@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] security: allow finer granularity in permitting
 copy-up of security xattrs
To: Stefan Berger <stefanb@linux.ibm.com>
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, 
	roberto.sassu@huawei.com, amir73il@gmail.com, brauner@kernel.org, 
	miklos@szeredi.hu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 5, 2024 at 1:25=E2=80=AFPM Stefan Berger <stefanb@linux.ibm.com=
> wrote:
>
> Copying up xattrs is solely based on the security xattr name. For finer
> granularity add a dentry parameter to the security_inode_copy_up_xattr
> hook definition, allowing decisions to be based on the xattr content as
> well.
>
> Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
> ---
>  fs/overlayfs/copy_up.c            | 2 +-
>  include/linux/evm.h               | 5 +++--
>  include/linux/lsm_hook_defs.h     | 3 ++-
>  include/linux/security.h          | 4 ++--
>  security/integrity/evm/evm_main.c | 2 +-
>  security/security.c               | 7 ++++---
>  security/selinux/hooks.c          | 2 +-
>  security/smack/smack_lsm.c        | 2 +-
>  8 files changed, 15 insertions(+), 12 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com> (LSM,SELinux)

--=20
paul-moore.com
