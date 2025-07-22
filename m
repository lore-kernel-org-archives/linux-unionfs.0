Received: from neil.brown.name (neil.brown.name [103.29.64.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477F5242925
	for <linux-unionfs@vger.kernel.org>; Tue, 22 Jul 2025 23:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.29.64.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753226516; cv=none; b=hnl0VYk8kDXlc/byIG2NwPJ/kT7onDPRHNWYw/antwsH6Nbo5kTRBz7OzPysof9qYk1VbwWLX+r7r0f2bBHzWX6rR2v70ZrJkaYODArF7+s4CJSDHuaB8qCcNzUzNKHik72FHjC19qeT05rOj1yJxCNerVJmSIMpBuhy0pEUYow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753226516; c=relaxed/simple;
	bh=eyOpbjxAqSY6staASt/3Q2ebwej58+iUw0TzlF8aV4A=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=gNcLHNVy5jLxaoOqMbFJNEWYWsRrtNpEwMRH60PiuTjwtO/RUfr5mx17smhtTfsqONTzIXN+FErWDx1nlhtMb7EVXegEeAhVufqBdt4ChPMsRljogVOb945q8J6SuD+WBsL1eDqreeFrZG/QFSMafjSRsQdvVG1TcVmXIQRtCcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brown.name; spf=pass smtp.mailfrom=neil.brown.name; arc=none smtp.client-ip=103.29.64.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=neil.brown.name
Received: from 196.186.233.220.static.exetel.com.au ([220.233.186.196] helo=home.neil.brown.name)
	by neil.brown.name with esmtp (Exim 4.95)
	(envelope-from <mr@neil.brown.name>)
	id 1ueMIp-0032P7-S1;
	Tue, 22 Jul 2025 23:21:45 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neil@brown.name>
To: "Antonio Quartulli" <antonio@mandelbit.com>
Cc: linux-unionfs@vger.kernel.org, "Antonio Quartulli" <antonio@mandelbit.com>,
 "Miklos Szeredi" <miklos@szeredi.hu>, "Amir Goldstein" <amir73il@gmail.com>,
 "Christian Brauner" <brauner@kernel.org>
Subject: Re: [PATCH] ovl: properly print correct variable
In-reply-to: <20250721203821.7812-1-antonio@mandelbit.com>
References: <20250721203821.7812-1-antonio@mandelbit.com>
Date: Wed, 23 Jul 2025 09:21:45 +1000
Message-id: <175322650522.2234665.2935541032065481555@noble.neil.brown.name>

On Tue, 22 Jul 2025, Antonio Quartulli wrote:
> In case of ovl_lookup_temp() failure, we currently print `err`
> which is actually not initialized at all.
>=20
> Instead, properly print PTR_ERR(whiteout) which is where the
> actual error really is.
>=20
> Address-Coverity-ID: 1647983 ("Uninitialized variables  (UNINIT)")
> Fixes: 8afa0a7367138 ("ovl: narrow locking in ovl_whiteout()")
> Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>

Reviewed-by: NeilBrown <neil@brown.name>

Thanks for this.  I would probably go a step further and make the "err"
variable local to the two blocks that it appears in - then this error
would be detected by the compiler.
That isn't necessary though - this patch is good as it is.

Thanks,
NeilBrown


> ---
>  fs/overlayfs/dir.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 30619777f0f6..70b8687dc45e 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -117,8 +117,9 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
>  		if (!IS_ERR(whiteout))
>  			return whiteout;
>  		if (PTR_ERR(whiteout) !=3D -EMLINK) {
> -			pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nli=
nk=3D%u, err=3D%i)\n",
> -				ofs->whiteout->d_inode->i_nlink, err);
> +			pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nli=
nk=3D%u, err=3D%lu)\n",
> +				ofs->whiteout->d_inode->i_nlink,
> +				PTR_ERR(whiteout));
>  			ofs->no_shared_whiteout =3D true;
>  		}
>  	}
> --=20
> 2.49.1
>=20
>=20

