Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E08311C06
	for <linux-unionfs@vger.kernel.org>; Fri, 20 Feb 2026 22:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771627678; cv=pass; b=fWK4tMRwM7Get4DBkQyNcls5Yn/Rshbqt7hgYgekbavVLCWR52wKLWNwXwyhxLhCONDk0sui9duTnwNUsXDN0NsUAKnT87RO7zR4DKFvblFjhw4J9VW8ZRYuwiny1MIAcc8FEbSRLqdAw+pD0npRqlJ82SXv0r1EQyP5U5qnavU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771627678; c=relaxed/simple;
	bh=cSO5ddvam+3etx0tA+nKexvNvZkPWOiJ4oLj72nGz0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KUyzvmEDfuRaSKeLV7viQo0a6pKY0HSLeidcYusycNP0ymVuM+N24Gz3MnZIOfhotUVS2IoDPAEpdkUTnbl3C2m8k5nLtFrhemt/GdnVxLZjgB2L8UWuk2qGkAYKuOUDANuObYZ/E5FfOhWcw5+ao/6pWcFhlI+IGZmzZJIsW+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=YdaW2WuQ; arc=pass smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="YdaW2WuQ"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c6e5998f90dso919187a12.1
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Feb 2026 14:47:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771627676; cv=none;
        d=google.com; s=arc-20240605;
        b=Y/oLlSH6RLEG/GuFSey8pq8s26kVSi6uUPl8xdgr58G1VNFxwrVimXzHGQDJ8N8d6y
         QQbddDH5XdXEYd0i8tJWwOI89QzppLBR+EFr64DU6IBOUvI8/05vQgcFDJ1CX5vmDolT
         tWYH6f34ogMOhp8nRYFBIGQAbtVby4AktOwsFL2310OdoBnUwWsET5vmSSQozQiFNTJO
         CTzEBl5LfZ2qfjNFveNGy928CmBLoTF0v1mI5LVo7QkMuxfsTAshUTbFOa0tVLEvci06
         bcYjmxiabOxCvxMHQe2c5BoVFCJxToB7ZtP+/JKhQRikxBj2GNvkGBYWkTythwN3wQ7g
         0VtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DDXd3tXPluWk2oCytZ/1RJVm/UKOezpDOPY6avX6ips=;
        fh=49caIbvUBmiJXVWVE73peq2UmHUx9cjL0Dc9+0yicBM=;
        b=LsNmezCuux93/cPgVIjLTNLHYTdvw3DDbyK94defMlLHLXATUGlUeCMrbVc88vaoNJ
         Eb3myJ/c6ayAJvOCbTvFJaeJCcYQ0EDVpt//92T92tKCwxoLROtK9Ey2Z9n0SgyIMKO9
         GgyF3UvPI8iec+bxELRYdetVMN8z8CYLUAmNYw5dKMgYPE6ukhfxVeyxHMi8qllOH2ZN
         DAnMsr+F7G/fsUP8p9G4YBvnUIbpQhQlz53la6oZMj3w2xWJDfMQtw+JznE4vgTH53x/
         Fl603WITVN0K18858DCHcD74NnCJZEPrGUgX/qTXnY4hzjkhWqCKuNzF00MdGTSWG51b
         pITA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1771627676; x=1772232476; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DDXd3tXPluWk2oCytZ/1RJVm/UKOezpDOPY6avX6ips=;
        b=YdaW2WuQ41wM5N1ATcsiXfFOfi8o+6IN5OMQAoEAgbdAjJkGfZ63rBEdcJ8rnXF3yy
         zZPc6a4bONe+ldk+YsvYsyF2kj29Z3wp3gNZOieGr1bx02kYKEQmVczXkyhrdPBmsOu+
         02nizDc9/b0WQGtrOR1H3GqDf0CUX/xKMH2X8B4mZpv+1BEK8dbBgL7id+rR5kElX7Bx
         n0PhraKR1StZolJE3zbIKZZSH2znoCletYgDWkfimFsMFY3R/x3k3KRCEkMEvmLYEC89
         hBRTOgyFJXJMoXD0XtDvmQ6JKkjmqmwBDtqojqDUbUMVLPW7sn6eTqD1FLjRPj4//pn+
         8/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771627676; x=1772232476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DDXd3tXPluWk2oCytZ/1RJVm/UKOezpDOPY6avX6ips=;
        b=SI5jdMTV9O/cAMP/xo4eNtRkdJ0mK2CXWKwtbCbrwSB662dek1TkWQNlzIp55V7Ixl
         862Sr/0A/sgM+ZCSp0A4ruwlJupG5nqWeqelHwP+zhcqPf/7+IWLQ4DpzHOqCZUJ7Rol
         XqgUOXQOwl5bJu6bcBBSWbXHtF0CvYDWtWXkMWPOMo6PqeQjgpHI+UghjSIbTmyQhII7
         YpUUOJfgd6AkwFme19HmcfonnNg4uiHEmE5ouWtBRoeueBGj/HS/ah0fp0CSHGu7+2qD
         0gA4E+vRbPEadijuvrS2aPio8vGxaBApTPyqWD9pAVXMlFausjQgGDHxJfvWlBy/iC3R
         47xw==
X-Forwarded-Encrypted: i=1; AJvYcCUWkOeJKFio20WtKq+f/77+ywK8Hr6AUqnYm53kmT3vE4dpx2Po5V1Vf3meYk1AN2vtywrxilsdhssN+fLQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwKhKnhkMAKqY5nfeGRyASiYzmtH5O9ot/eKOFh/27Y8os6ZsFS
	2XL3TgNEMg0+Fhm8xNuL1CWsAih0xK7Huzt6pbyH1SqHTwQnR16UbkfgcSXDCt35rL5CBp2yWm8
	I1jUsQmmQSXvqR+MbW8XEW+8aokIgq8dD5vEFvHSD
X-Gm-Gg: AZuq6aJHjKNiCdgnUIzqWFnsf8zzTLR96gyfkuNcEM+sCuIRPSqj+Ezo2OWtoNw10/o
	KrysSbWf2Mo8pj3luKZNDRsKmPuw5fycUQKcF9I+OweFmN185Sz62vJQ0kNlsNXYwb3euhqUlDW
	I3DJL31/MhzTlu+gazmURTodhGK4hbOU02yjurBXRf8rfWxjd2DeYIgJQPJBJjep5PxKvLZzmXT
	yPdKeoGGNeRwgjTkVQMieeleVVhCw4PRt0DV0D7opZGpRXRR0yoTbhupzXmJV0IRHOkXjODMI6t
	SoLeNTs=
X-Received: by 2002:a17:90b:3a08:b0:34c:fe7e:84fe with SMTP id
 98e67ed59e1d1-358ae8c0983mr894544a91.28.1771627675691; Fri, 20 Feb 2026
 14:47:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260204050726.177283-1-neilb@ownmail.net> <20260204050726.177283-6-neilb@ownmail.net>
In-Reply-To: <20260204050726.177283-6-neilb@ownmail.net>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 20 Feb 2026 17:47:42 -0500
X-Gm-Features: AaiRm531rz23NInLiaMybHfJxR35OGBc7KTvM6WC-U0WofFc5pma3F6ygsFUv1A
Message-ID: <CAHC9VhThChVk1Dk+f-KANGj7Tu7zzHCiA==taeQ+=nQaH6a7sg@mail.gmail.com>
Subject: Re: [PATCH 05/13] selinux: Use simple_start_creating() / simple_done_creating()
To: NeilBrown <neil@brown.name>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, John Johansen <john.johansen@canonical.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, linux-kernel@vger.kernel.org, 
	netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 4, 2026 at 12:08=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
>
> From: NeilBrown <neil@brown.name>
>
> Instead of explicitly locking the parent and performing a lookup in
> selinux, use simple_start_creating(), and then use
> simple_done_creating() to unlock.
>
> This extends the region that the directory is locked for, and also
> performs a lookup.
> The lock extension is of no real consequence.
> The lookup uses simple_lookup() and so always succeeds.  Thus when
> d_make_persistent() is called the dentry will already be hashed.
> d_make_persistent() handles this case.
>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  security/selinux/selinuxfs.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)

Unless I'm missing something, there is no reason why I couldn't take
just this patch into the SELinux tree once the merge window closes,
yes?

--=20
paul-moore.com
