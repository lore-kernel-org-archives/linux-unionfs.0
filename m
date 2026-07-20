Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6861F938;
	Mon, 20 Jul 2026 08:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784537141; cv=none; b=t2jxTKK4M47Hd99BOwXy1nNxyYc/SSwsbkXmVWusgjN4ccB+eY+cBWMWiqaMqXKzAgafSyglsd4JIvlizU0cNtvP4QKBB+zVJqFi43qoPcSWPe/ZPPMlBLmj7H8W2AybMwhYnjuEEZkNnRPIYgmC8zhJpMqX/bLDfIqCJGGp7tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784537141; c=relaxed/simple;
	bh=7MPWJRCU3rlzlcvJ6Lg2L32JYHbQvX5x+WmSWLO2U4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BiOpL7wV3Lz/Y8bSYI0PutDEb0zfZsYJzj1hPsyHYsVYCgeHZbgEw3SJ5HiFNM5m8/fR9OlIxsWhU3INglo2G8GxdqZbqdXixdbUvmnt5rETrMnXs5LJChdeqkNAjmWf41K/KHAl6kMPEWdlQMvytKXXtG2ph2WIOD+26sKP4vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=UrfSUxwI; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="UrfSUxwI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784537137; x=1785141937; i=quwenruo.btrfs@gmx.com;
	bh=BhZimL4xPZi3pUEoT+oD9wvSLRMP0NFgMCv/77Uro2c=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=UrfSUxwIJy7cdj4Vf2yhqjaTZkGAP8bwkLIZJoVuG3Rwk/gF8cMmkCf29En9Vo6N
	 n4BKvZnACbXQDlepQvMgiV6a0OPBY0vWEF8+cqCXMbgJOc5Q5j4n/5ZNBi8ABEqCA
	 fQ+iTz8a6IG3s7IXISrGUyYI/VuUg1bmB/cBoeudUYx6hSK57yAf48QGkkamTCu9U
	 rIIDqB0gjkkuzhT2iiK4mSqu9HIb/fWZs7tmEmZVgE/gmjVpaFG4dW0kNNTZ0KzLw
	 gcffwMYhI5VYLLbh0WNlX8aB3B+4xm4OmuDkfhjljNSmAyhyuk8202EA+UEZ6jW/J
	 fUw8iyN358y1UhtJaA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MhlKs-1xGPg01zNI-00jpU3; Mon, 20
 Jul 2026 10:45:37 +0200
Message-ID: <fbfbafef-2b42-4f5e-ac8e-9c680a0be5ad@gmx.com>
Date: Mon, 20 Jul 2026 18:15:31 +0930
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] src/vfs: probe O_TMPFILE support on the base mount in
 the idmapped tests
To: Christian Brauner <brauner@kernel.org>, Miklos Szeredi
 <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 Zorro Lang <zlang@kernel.org>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 fstests@vger.kernel.org
References: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org>
 <20260615-overlay-idmapped-vfstest-v1-1-c6b3b2228092@kernel.org>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <20260615-overlay-idmapped-vfstest-v1-1-c6b3b2228092@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NfzMuBdKieQ+KN1k6Ngc51I7yYs8ASE/S6xXJqQEuPykF6Nxx2a
 q1HcAIR7S5voJ1VTg4dg6jrz+scsfDFDEzP389SG7HvjO60AG6re/ydNrXuzQwwLkwLJo3X
 kMts0Pkdvoz7N5paGLLOTOaF1krq7QZoy9RB13qJjAtPoN2gafznVIE3RgROVjzGp2yRfyZ
 jCmsdr78/4frfYHBS23ug==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3sSAYnCH8hg=;5jNp0y6/EIPtU5GngL9KxJHLVa2
 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
 gjt4DAyHJLWJE7ANfm4vudYTW1yo+q



=E5=9C=A8 2026/6/16 01:03, Christian Brauner =E5=86=99=E9=81=93:
> openat_tmpfile_supported() in the idmapped mount tests probes O_TMPFILE
> on the idmapped mount (open_tree_fd) as the test's fsuid -- but that
> fsuid is not mapped by the idmapped mount under test, so it really asks
> "can this unmapped caller create a tmpfile through this idmap?" instead
> of "does the filesystem support O_TMPFILE?".
>=20
> On overlayfs this is a false negative: the backing tmpfile ends up owned
> by an unmapped id, overlayfs opens it with O_NOATIME and may_open()
> returns -EPERM, so the tmpfile sub-tests are wrongly skipped.
>=20
> O_TMPFILE support is a property of the filesystem, not of the idmapped
> mount or the caller's mapping. Probe info->t_dir1_fd, the base mount
> that the caller owns, exactly as the non-idmapped setgid tests already
> do. The probe then succeeds on every filesystem and the tmpfile
> sub-tests run as the mapped fsuid.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Furthermore, since kernel commit 539dce114465 ("fs: refuse O_TMPFILE=20
creation with an unmapped fsuid or fsgid"), even without overlayfs the=20
involved tests will fail due to the extra checks.

So this is not only affecting overlayfs but all regular fses now.

I hope we can at least merge this one asap.

Thanks,
Qu

> ---
>   src/vfs/idmapped-mounts.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/src/vfs/idmapped-mounts.c b/src/vfs/idmapped-mounts.c
> index ed9992f9..8f8441c9 100644
> --- a/src/vfs/idmapped-mounts.c
> +++ b/src/vfs/idmapped-mounts.c
> @@ -3838,7 +3838,7 @@ int tcore_setgid_create_idmapped(const struct vfst=
est_info *info)
>   		goto out;
>   	}
>  =20
> -	supported =3D openat_tmpfile_supported(open_tree_fd);
> +	supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>  =20
>   	pid =3D fork();
>   	if (pid < 0) {
> @@ -4014,7 +4014,7 @@ int tcore_setgid_create_idmapped_in_userns(const s=
truct vfstest_info *info)
>   		goto out;
>   	}
>  =20
> -	supported =3D openat_tmpfile_supported(open_tree_fd);
> +	supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>  =20
>   	pid =3D fork();
>   	if (pid < 0) {
> @@ -7733,7 +7733,7 @@ static int setgid_create_umask_idmapped(const stru=
ct vfstest_info *info)
>   		goto out;
>   	}
>  =20
> -	supported =3D openat_tmpfile_supported(open_tree_fd);
> +	supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>  =20
>   	pid =3D fork();
>   	if (pid < 0) {
> @@ -7947,7 +7947,7 @@ static int setgid_create_umask_idmapped_in_userns(=
const struct vfstest_info *inf
>   		goto out;
>   	}
>  =20
> -	supported =3D openat_tmpfile_supported(open_tree_fd);
> +	supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>  =20
>   	/*
>   	 * Below we verify that setgid inheritance for a newly created file o=
r
> @@ -8181,7 +8181,7 @@ static int setgid_create_acl_idmapped(const struct=
 vfstest_info *info)
>   		goto out;
>   	}
>  =20
> -	supported =3D openat_tmpfile_supported(open_tree_fd);
> +	supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>  =20
>   	pid =3D fork();
>   	if (pid < 0) {
> @@ -8536,7 +8536,7 @@ static int setgid_create_acl_idmapped_in_userns(co=
nst struct vfstest_info *info)
>   		goto out;
>   	}
>  =20
> -	supported =3D openat_tmpfile_supported(open_tree_fd);
> +	supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>  =20
>   	/*
>   	 * Below we verify that setgid inheritance for a newly created file o=
r
>=20

