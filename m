Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792485571;
	b=pPoA2L/eZDSzup0ruhIpIYvYSidN6wbmNB9agQUQs/8uKVQprgI6vBSDn/OgjxIcHq3a
	 MbS9gLbN18REXVnL0WQ1ligDGTdgbITR6Xtz0vHjTMlm4LENQEvXcTaPvlNLvArtn7xPM
	 VJqw7SBt5FzI2wLqAwkYKQ3qx6nis6aPqjtd0V5XdPybtkBEYfN5lQa2azRwGi/GNz4AZ
	 96M6zHTvxugB/SkbUq5Dh/rSb4YeBYmSK2uLEAJt8MbYZP8hZr1N+s1xvHhJHTXU+oqKQ
	 YNi26V35ew7YJbIDJ9lgcpijnW0aIgjzHkMZi50SCDr4lUlT1Jv+h8cDP+nEgcmz/yw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792485571;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=RfLpTPAhPd28vtmcJfKwJOyT8j61Fqz5N+ThO6odozE=;
	b=JLZ7cc2Hf25kE1nunsDSVPW/N78W9MY+cZH/ObtV8EZm4l+/rC2CxQD2Nvi2QUWekTfP
	 a1tidEznB1Cy3fEwNbsGoKBqjDc7D0PKR5i2iOFnoAsbYwpwiVZg64ClYac7jvw52DMA8
	 023FfCTau4o3ekge5izxoFFRdyRrnKNHg4riGfuglTL/W7n36k+G66LkgmSONTnxyWnBv
	 C8V+Nis0kT/OwkHyxf4zbkO+78qqueD5cWfR1Es7SZIxcUOG99kXcnpCmRm53bGUeqICg
	 jPPpDths3WGEAjjGFYpmD7OjhAw97z5FOu2NkN2WXnawRgSrPty4qZidlTHVJFYOeAg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VY2vuGJT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60B2606A31C
	for <linux-unionfs@vger.kernel.org>; Tue, 20 Oct 2026 08:39:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E60B2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VY2vuGJT
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c414e5d282eso341872966b.1
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Oct 2026 01:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792485569; cv=none;
        d=google.com; s=arc-20260327;
        b=ra02twkG1ppItB0cfkmjk+dceLFZYUXWymIKkLPaXWZtuvU1gRDqZRJhaYsCT8g6Cf
         ANBXXzmK3NEh/W1xwHh793wzqg9oQgGZyliAOcioKp297CXbBKOVEY4Kah1GBNdTM37m
         71Uvf9wW7C+HGoTGzhnJPRk6duHaP4+9RzW5GlADDsckNAHvkc3YYOCx/6cv14jRJ5cd
         JYn2GQTst+Gq5vJ67WBaAYF8x8yESA6Z8a67RJ/HxEjr+M+hk2sSUsDQno6i7a0z5r6w
         6T8aCDtL9uN7R5FAEbizIC1nJNtZLUdqMGa1mxq9w1UPMxo6RoPRu1BRke9yfF6Eyogk
         rktg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RfLpTPAhPd28vtmcJfKwJOyT8j61Fqz5N+ThO6odozE=;
        fh=ebKpZR/2cnmXCSlNijm2iwOVX9f5OkvJQA9MBb4CT0E=;
        b=HzGoBF1tS7Ynvwpcq+hu0r6kCXUhTNLxxw6glraRsy4ftr2etpQQ48S4U1ICkLFth9
         r12qUhTLakrbgASuDxZ9v8Qt2K8+JE9O1sKLFavisqsXZR9AEHEbZ5zN45WXG3yk6eER
         8VKIjdAM+bD4vrRy+yDgwwhi066E8AFZLXgbgJ4hwRY3sC3Xs+gEIDAT9HUGlTjG2yPN
         JPChp5WMHKErmiMfSOlFcBuQ8KdH9zpCbRGfy4J34QO/T5OsOONYHCQKz2h03O0GfG1Z
         uki40GLvy/+hZPeNB99ma3q96/axIsHXOno3Vrx11OyB/Guius5/+ZdrgVqMZrSQ7PO3
         drEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792485569; x=1793090369; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RfLpTPAhPd28vtmcJfKwJOyT8j61Fqz5N+ThO6odozE=;
        b=VY2vuGJTmoCSLOOYWdIX2nZALUdQZnUfICIhBT+/e3LFsU2QLZfLHACxDGcbiAWTeF
         KOWNusiWI0qx/eFKnL7837ZCjkzRkDZp85C58+AeGgcvnkH8dWx0amORY80DdeFB74T6
         jAOfIurcKuptsnTGx6oIChEHIPpkBGXAflVOvi4clOeTcTkv/9q/gDNO4K1PL5p60hRh
         l0SqQfCW/nFh2eIdVC3kGGZGzezjx7N70daYazFJHKg+A2xGB05EOQ+I1nOCd9pNukoX
         Ywe87ZmAxVPd+iCHzgKtkA8Dud0INZel7kegWcE6HTw0kNGIEuuO2AxkJJl6DTjq5snu
         Ip3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792485569; x=1793090369;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RfLpTPAhPd28vtmcJfKwJOyT8j61Fqz5N+ThO6odozE=;
        b=l1TwFSDho3fCkTx/gDw8nZYz3Lcyr/MD1B6c1bMlwqZ5kQ2LczODWNpGE7Yizz/K0t
         it1BCeaCJZY6Cy10mJd43I1NsVanLIntjwVC6WMbEpeTsFAxYwJMm7UlkoLjt5saIJFM
         y8f/JCim7LIJ9RE4NhE1n6VUZjTYYjdrbf7vudLRbqySHXvmm6kUBnyatILagcV4PkMR
         6fgXnEZ+Dzmbr37awFKHnXVEL6zxfZldLGF97oADUK5Z6AcQB9A2hUHLajIHcxNRBdGp
         5FadNrKLeJVbMMFFdSsNHgvaaVqvXRzdCTubDRW3vo+Lfr6JJstnc8HhqgBQski0fQp1
         +iTQ==
X-Gm-Message-State: AFq9FYJGfU43yIZPZTTI8cVe/YYgo1pZB3FH0t+0qai+dZgcHr8XhEhf
	xSC7OaAjEoo1NazNqPN+nkxv/3CepWjq1kpu24oqfIwy7udiMTympE3hv4PmDPH4X2yqiqoGmL4
	cpWRRd7Vv7vPVPhj72zo3ZyvFQBbkDsM=
X-Gm-Gg: AYBFou08dx3y7JEJ2PHQH7cwNJ9ngsAib/iEbvKeJ4f01FW3UaVfWQET63PQoor1cY+
	UNQJCG07vYpWH6ONiX6aefeIuNwYA6rdbh1JSrJyWhFn3S6g9Y3pUu3YFTWYz4nW+jdHdHaFrLs
	aJLbcWurlKv1wk745yb1IEPKdbs3KKzF6c3KCne0SZWqNV4OLywzKBr5BlM0rpCJYtawxDQo1fM
	itwQ+/IxpYE0d7ezlxwrpA1/GWApqntvJCxtPjjNIruYvM2f6hI0HyI5jAjonnb/s4t5RqN3U4G
	dVKSU0UepFoOaDSWR/l7YrgeZk25vbE3JQTVL/NP3UTwXnHD43Anz8nRNEjAQ8o8o0ptLFl/+7F
	UfWPvz16slKJXqb3I8BUzXe9QUhUp3a/8QpN+xJZfSFyVKpkShI7s2nBl9jnsFm3oH0Xuqd8=
X-Received: by 2002:a17:907:ea8a:b0:c40:33d:f06f with SMTP id
 a640c23a62f3a-c419f90862fmr798573666b.39.1792485568993; Tue, 20 Oct 2026
 01:39:28 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CACs2WyyyGBxznvnJRDYWziAbzz8QROr41CF9Wtu9fOj7jX1fDw@mail.gmail.com>
 <atbfAjLsKxhkqW-q@mit.edu>
In-Reply-To: <atbfAjLsKxhkqW-q@mit.edu>
From: Claudio Fernando Pinto <claudiofernandopinto@gmail.com>
Date: Tue, 20 Oct 2026 05:39:16 -0300
X-Gm-Features: AclHuK-6XOMoF2Xy6v_44hxLIRsnJt30hyvtuLK-Lk88hbxNuzPppNESROGHRHA
Message-ID: <CACs2WyxC0J4Nv4LvW9Jg6yzVLaK3hOWOaUiG4xSMFEK4_dXyRQ@mail.gmail.com>
Subject: Re: overlayfs: unprivileged writes can use ext4's reserved blocks
 with the default resuid
To: Theodore Tso <tytso@mit.edu>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ted,

> I'm not sure why overlayfs is trying to override disk quota limits.
> What's the background behind this?

The drop came with commit 51f8f3c4e225 ("ovl: drop CAP_SYS_RESOURCE
from saved mounter's credentials", 2017): "If overlay was mounted by
root then quota set for upper layer does not work because overlay now
always use mounter's credentials for operations. Also overlay might
deplete reserved space and inodes in ext4."

> Also note that if fsuid is 0, then regardless of CAP_SYS_RESOURCE,
> any writes will be charged against user 0's quota

I think the charge goes to the inode's owner, not to the writer's
fsuid: dquot_initialize() takes the user dquot from inode->i_uid
(fs/quota/dquot.c:1450 in v7.3-rc7), and ext4 charges blocks to the
inode (dquot_reserve_block(), dquot_alloc_block()). overlayfs creates
upper files with fsuid set to the new overlay inode's uid, i.e. the
caller's (fs/overlayfs/dir.c:665-676), and copy-up keeps the lower
file's owner (ovl_set_attr()). So files written through overlayfs are
charged to their owner, and with CAP_SYS_RESOURCE lowered
ignore_hardlimit() (dquot.c:1243) no longer lets the mounter's
capability skip that owner's hard limit. That half of the comment
seems to hold; the reserve half doesn't, since ext4 grants it by
fsuid =3D=3D resuid, which is what the comment patch says:
https://patch.msgid.link/20261019-ovl-comment-v1-1-499b532b69de@studiomoob.=
com

Please correct me if I misread the quota path.

Thanks,
Claudio

Em ter., 20 de out. de 2026 =C3=A0s 00:55, Theodore Tso <tytso@mit.edu> esc=
reveu:
>
> On Mon, Oct 19, 2026 at 06:03:17AM -0500, Claudio Fernando Pinto wrote:
> > Hello,
> >
> > ovl_fill_super() lowers CAP_SYS_RESOURCE in the creator credentials wit=
h
> > the comment "Never override disk quota limits or use reserved space"
> > (fs/overlayfs/super.c:1511 in v7.3-rc7). On an ext4 upper with the
> > default reserve owner, the second half does not hold:
> > ext4_has_free_clusters() grants the reserve when the allocating task's
> > fsuid equals s_resuid, 0 by default, before it looks at the capability
> > (fs/ext4/balloc.c:654-657). Writes through overlayfs run with the
> > mounter's credentials (ovl_write_iter() sets .cred =3D ovl_creds(sb) an=
d
> > backing_file_write_iter() applies it), so with a root mounter the fsuid
> > that reaches ext4 is 0, and an unprivileged writer can spend the blocks
> > reserved for root.
>
> I'm not sure why overlayfs is trying to override disk quota limits.
> What's the background behind this?
>
>         /* Never override disk quota limits or use reserved space */
>         cap_lower(creator_cred->cap_effective, CAP_SYS_RESOURCE);
>
> More the point, why do we have creator_cred in the first place?  We're
> not lowering CAP_FOWNER or CAP_DAC_OVERRIDE and fsuid is 0.  So if
> we're allowing some file system operations with the mounter's creds,
> why is CAP_SYS_RESOURCE special?  Also note that if fsuid is 0, then
> regardless of CAP_SYS_RESOURCE, any writes will be charged against
> user 0's quota, and user 0 doesn't have any limits (often it doesn't)
> there won't be any disk quota limits anyway.
>
>                                                 - Ted



--=20

-------
Claudio Fernando Pinto
