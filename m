Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5FD4534A3
	for <linux-unionfs@vger.kernel.org>; Thu, 26 Feb 2026 21:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772140318; cv=pass; b=KclYF+QF8DH8uQ8CVkwEnjagqDuoEBHB5Frr3ALQukb8aN2wB1SrbB3e0dWC27COkwUgPdXqfWr0oD5i+wEi3iMaM1gT3ES5UOdb2Ms/Di1zT1w5yaBAQJlzP+MSmRY827+3Uw1cefp32iL+Gp51ZWFepvGRhwfV1NOkPsbDyfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772140318; c=relaxed/simple;
	bh=bnDaNoU6qjKfC/eAGGjHl/JBEfLQ2MSCDsq35dJ1WO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VFJvEIi+Tp5z/23RbYFLbq02HWEBoyfMZsQg0bikdJMpImbvqwA1UBhSPUohP1KdkB8aL5VQOjWsMb8JtLp5BxcVC1Joq9Nf65zWnISi0S+jxsBw6LW/ZleXcgbJav9u0n/wIIEcPjY7c2EWnPf5vCB3eQBcfWGestU+7J+s1Io=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=HW/o4Vat; arc=pass smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="HW/o4Vat"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c70378ddaafso860412a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 26 Feb 2026 13:11:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772140314; cv=none;
        d=google.com; s=arc-20240605;
        b=JDIKlfuRaYM1a7E7Ncx+B600LssHBQu0UkHux7ZC7b3SLIsNhXtex2DVCRxgtbepIW
         LF73SIZu3Q4y4ZA6OD/6JOOq+kyXXyNnDm6DPft2uqeZ+/p3PJDTNncRq/yEfHRDFmns
         +5ucgHbyhg40iD77AAwK/lODoEoOZLCwVlx41npV9hccQmUFPaTUBtScA0gprXxhLVu0
         3UygjS1jekJwKrKmxtyQrSgzqyYipL/I0rFqChqzZI5v3zH42+8KKaTDhIEdkjawj2xM
         kJoAOW2WmaDgXB/e9j+IpE4fIuxPVlzNdnsTeU5U2pbAi6hQii1lVBotGFH9PsM25vm7
         cn0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zmNhsrxkJsNmzJoSll+GD0SvmHq0rQdZiw5NaBd3y6o=;
        fh=/lmZE0oWlJtp0184NpX40PyCtLy87OeHUnGMwV+2ObQ=;
        b=RQbFwMcjSp4ANS21k1rr2pwTE2/7iTc+O8HOlOtHtNvaNnGpCb8eT9v1lGFojwJpUI
         nkhEdzcj0QVmOByl/oIgMn97ikuDXkmhWU4bExJyFdpx4ir2rxQ7UqcbHPO9YCNYWdSB
         3mXfcDn/Art8IT0vbjpnqLxZFriNdNsmRsy6UmLuYbSt4UO+X8GHNnwTRTHyNSFiEgxB
         nYpnttz8Bdh/tjBSyqL5/E2+rYHV/3JGRH4I7dvARsvwVDX4tibabCFCx0eeUIxJNOZH
         93zXRS19+mrdsl1dQ6eKVQR3ZnaRaHaKpwJstq35Pe1aUvk04GWo5mN7GtK4KnmkerUl
         OpWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1772140314; x=1772745114; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zmNhsrxkJsNmzJoSll+GD0SvmHq0rQdZiw5NaBd3y6o=;
        b=HW/o4Vata6iL0319Ebvg+XwcmFV3aXvPxwJavhnSNkrdZzg0DUnb3gyhur+Z5qjlLy
         DF8ktagjV0h021ZkfaIiy95wdENx8nhp/3Vvz2748i/fBYrVuloVbagkkQGgRNG86+Xf
         7YlzwOmtdpv3bWcOUuDxueD4ZLfhl1dx7sRZkDnHp2PU66qfJaPiPJAVJ/M8KD8ERzr8
         bIQQxKK/DZLsihhNuRa8yQlW78+eqc562C9u6niHHz0B0ONpkKGa75Gk3umCQziU6XHm
         celOWJX9fFF/7lcRec9du77GkDGs1yNtYP28Isk20pFkO0mQFH92SHVI+gBYVb/yj5+Z
         wXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772140314; x=1772745114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zmNhsrxkJsNmzJoSll+GD0SvmHq0rQdZiw5NaBd3y6o=;
        b=R/hiMXB9frHlZfj9LoJi/+gtMpxK4wRFvV1NHesRC8taaNBSajyR5zyew7qjOqI4GW
         gv18BZfmRYYxA86Cs0dxfdmVCs0x7IN7k9K69LsXBPuXILx2QKuOyAAIixkrGBEMhnGa
         MA1YB8hTBMphqPLzfMZI5ooAHOZ2F+DCCjULHO7rqwK5wI9gTwTlnLPXoLYn0jDkgdeh
         +W35t0mGFc4UTQvdgRm6LGv+qtHwbFMwdyL0M6A/fe1UPOm/8TSbzHxL0Bv4jlrqhjpA
         U298eEp8Z39FP1xwyz8lEoDu+PyqH0rwml4E/CtUg/I4duBPSFXiuSIvroXpI50ngJBQ
         7G3g==
X-Forwarded-Encrypted: i=1; AJvYcCVaFLtfBD6uANKanhO3CNyLf53n8eufFi2qK4c9P2HSCH3a9y+h0bpBSC2J8DhJ7LG6U4v5PyzgMJ0wzyO9@vger.kernel.org
X-Gm-Message-State: AOJu0YyD6wEA2M+rsjsrzVlqERDjq/CdpBvS73eQx/zvno/gdHoRvoSh
	4atZZfz2Ey1givElF1aDHIYJw1A/Qo3+4rvcHcLrJIriR5htbAOdySifHZXsHJOgWTsFFLhOSNl
	ugS/ISkexZEB1hj1ZCF6jzGhOLauEzGMHx3vNO8wp
X-Gm-Gg: ATEYQzzSKw7ln75RXXfBOg/bNinU2RYwJzEujBsgjW18h4WeA+2DSsbdG6TrcChVHIP
	rtGEOddu2m9wc+9fvn3gkmd5Vff3YXDFO4VomSugNqP9+6UwlQWBBh1aetXOYylc34XJFySgnyI
	hwpZKxOuNXc0CXHACJu9ilCLDAJi6WPH8UJQXs8et347RXksCiLpEB2ef5xwt7NVZ5Qhx0oxAsO
	ZtgJCfWToTm6SXES6tdqPNeqMLf99mBGX2jAG9MPcxnUE9sm48JrH5/pvQDf3NtJeW+1LPT7cYl
	XjNqtlY=
X-Received: by 2002:a17:90b:574f:b0:359:877:370f with SMTP id
 98e67ed59e1d1-35965ccf029mr498632a91.17.1772140313953; Thu, 26 Feb 2026
 13:11:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org> <20260226-iino-u64-v1-51-ccceff366db9@kernel.org>
In-Reply-To: <20260226-iino-u64-v1-51-ccceff366db9@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 26 Feb 2026 16:11:41 -0500
X-Gm-Features: AaiRm51CHDvKlRV2Z04ZUK5c4lU9AiJhpRFTzD6a70HHA0FgEKDqsojtRqG1Wpw
Message-ID: <CAHC9VhTPutzjNfYoRJigC2AQS4wz1A3vTEYn2koeR0kKetYk0w@mail.gmail.com>
Subject: Re: [PATCH 51/61] security: update audit format strings for u64 i_ino
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Steve French <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Alexander Aring <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, Amir Goldstein <amir73il@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>, 
	Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	John Johansen <john.johansen@canonical.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Martin Schiller <ms@dev.tdt.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, 
	ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, 
	selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 26, 2026 at 11:06=E2=80=AFAM Jeff Layton <jlayton@kernel.org> w=
rote:
>
> Update %lu/%ld to %llu/%lld in security audit logging functions that
> print inode->i_ino, since i_ino is now u64.
>
> Files updated: apparmor/apparmorfs.c, integrity/integrity_audit.c,
> ipe/audit.c, lsm_audit.c.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  security/apparmor/apparmorfs.c       |  4 ++--
>  security/integrity/integrity_audit.c |  2 +-
>  security/ipe/audit.c                 |  2 +-
>  security/lsm_audit.c                 | 10 +++++-----
>  security/selinux/hooks.c             |  4 ++--
>  security/smack/smack_lsm.c           | 12 ++++++------
>  6 files changed, 17 insertions(+), 17 deletions(-)

...

> diff --git a/security/lsm_audit.c b/security/lsm_audit.c
> index 7d623b00495c14b079e10e963c21a9f949c11f07..737f5a263a8f79416133315ed=
f363ece3d79c722 100644
> --- a/security/lsm_audit.c
> +++ b/security/lsm_audit.c

Everything in security/lsm_audit.c looks okay.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index d8224ea113d1ac273aac1fb52324f00b3301ae75..150ea86ebc1f7c7f8391af410=
9a3da82b12d00d2 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1400,7 +1400,7 @@ static int inode_doinit_use_xattr(struct inode *ino=
de, struct dentry *dentry,
>         if (rc < 0) {
>                 kfree(context);
>                 if (rc !=3D -ENODATA) {
> -                       pr_warn("SELinux: %s:  getxattr returned %d for d=
ev=3D%s ino=3D%ld\n",
> +                       pr_warn("SELinux: %s:  getxattr returned %d for d=
ev=3D%s ino=3D%lld\n",
>                                 __func__, -rc, inode->i_sb->s_id, inode->=
i_ino);
>                         return rc;
>                 }

Additionally, later in this function there are pr_notice_ratelimited()
and pr_warn() calls that print inode numbers and need to be updated.

--=20
paul-moore.com
