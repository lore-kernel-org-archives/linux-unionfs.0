Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793605747;
	b=XFel3xlwt3ukQTGjN31eNY1QcozI//S2n0zln7CQsUVt94MSEEuYPnI+YgwptITyrTOb
	 m/3wrI1gjoq7WvPzagpJ1HCv1hnOabSMPmxI+4GMiiaqcIswyNVzekoqZWccHWd9KPGnd
	 ZIZmSE+Za4PM0yYqX++I19djqrIhk8Ga8FFFHk/SjZnAVEi/2QXnmcfMWQnC701URUP0m
	 8DF2S4N0WYF4a27SVAAJP9sFUt6rYE5kcSYUstpoFQKy2hUcutLQCn9jYdGk4tVTSGoFR
	 58f4kI6KQiLKn2/EoMjL/D6x4iJB9jXB66YZDK61m0ZY45NH+LQ7EZ5gSQccS/V55lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793605747;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=6zy/VYbKANYR4oQb01WEa95GVXRxz6MyaP3JLTWfyqs=;
	b=HBGCM2LpDdGNIgAf5RsEdJveVqzv4z92RJQOSkU3s95Hv7lICsWGTdX3uRyIFda92QUz
	 yAptGFdpps9cjEh62VBW5eam2AR/HpwOtaaz1TSRMNvYCtkjDSde9YsqWvQ6Woya8Wn2r
	 naP2PtKVgl6eniLM1Y/96dgKn/Pps0pi9l12ZyUblvEoQQmc1ODN9Jgyfj2UmniM4eHG0
	 flJIvaPe7r3KTteLu5uVGNyBfsU1KGMz95pkyFo9lr+n/DYv1nc77yR29Qw8CNw+/F9eV
	 glrtcwavsnjs9ydeu4yeP+GkUdjp98HX5v4GAn/0p3UbVG23TjJTKxPMr7/O7xKyFkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lq3xJB/i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8C7606A329;
	Mon,  2 Nov 2026 07:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lq3xJB/i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607F91F00A15;
	Mon,  2 Nov 2026 07:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793605746;
	bh=6zy/VYbKANYR4oQb01WEa95GVXRxz6MyaP3JLTWfyqs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lq3xJB/ibe/VGQrteBXbk1TFuHZ7+AqUtjMaw3XBchmQVbGScaKB13qH4pgQmTXIo
	 G0F/OBCE8sNAmWxHDq7A6Mhq0+bc9i8bAsjQ6LKRNsSLjhytWZ9xIePHWorhmzLq/D
	 Sy1xgKJWkjAkeaO4JNMgRBdZcwqqBxs0fuyyRXkVeCAZinFmEoMTKlhmO6g5ClUqu+
	 T3Z6GSCKP3NUJqpDR56iD6OBL+LDsJNXxBu+51w3p0ChYj30fkeCxUKlv6PmMSJxvJ
	 XdkK7QG1nur3oQZsAdYIVZjKW9FWIN00/NfiXZx8MPRaX67jQ4+iUKXFBVi237OYOO
	 Rya50vHwt3BaA==
Date: Mon, 2 Nov 2026 15:48:59 +0800
From: Zorro Lang <zlang@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] src/vfs: skip whiteout-device fixtures on overlayfs
Message-ID: <auhAJqt9uZgNtEbk@zlang-mailbox>
Mail-Followup-To: Amir Goldstein <amir73il@gmail.com>, 
	Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org
References: <20261017092229.2363746-1-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017092229.2363746-1-amir73il@gmail.com>

On Sat, Oct 17, 2026 at 11:22:29AM +0200, Amir Goldstein wrote:
> From: Christian Brauner <brauner@kernel.org>
> 
> The idmapped mount tests create a whiteout device,
> mknod(S_IFCHR, makedev(0, 0)), as a fixture: a whiteout device is the
> only character device an unprivileged caller may create, since it is
> exempt from the CAP_MKNOD check. overlayfs reserves a 0:0 character
> device as its on-disk whiteout marker, so ovl_mknod() returns -EPERM
> and the fixture cannot be created, failing generic/633, generic/696 and
> generic/697 on overlayfs.
> 
> Add a whiteout_device_supported() helper and skip the whiteout-device
> fixtures and the checks that depend on them on overlayfs. The
> makedev(5, 1) "creation must fail" probes are unaffected and keep
> running. No-op on every other filesystem.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Thanks, this version is good to me,

Reviewed-by: Zorro Lang <zlang@kernel.org>

> 
> Changes since v1 [1]:
> - Patch "probe O_TMPFILE support..." already merged
> - Repalce is_overlayfs() probe with whiteout_device_supported()
> 
> [1] https://lore.kernel.org/linux-unionfs/20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org/
> 
>  src/vfs/idmapped-mounts.c | 154 ++++++++++++++++++++------------------
>  src/vfs/utils.c           |  25 +++++++
>  src/vfs/utils.h           |   1 +
>  3 files changed, 107 insertions(+), 73 deletions(-)
> 
> diff --git a/src/vfs/idmapped-mounts.c b/src/vfs/idmapped-mounts.c
> index 3e1b6987..1cca86dc 100644
> --- a/src/vfs/idmapped-mounts.c
> +++ b/src/vfs/idmapped-mounts.c
> @@ -432,6 +432,7 @@ out:
>  
>  int tcore_fsids_mapped(const struct vfstest_info *info)
>  {
> +	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
>  	int fret = -1;
>  	int file1_fd = -EBADF, hardlink_target_fd = -EBADF, open_tree_fd = -EBADF;
>  	struct mount_attr attr = {
> @@ -534,7 +535,7 @@ int tcore_fsids_mapped(const struct vfstest_info *info)
>  			die("failure: create");
>  
>  		/* create character device */
> -		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | 0644, makedev(0, 0)))
> +		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | 0644, makedev(0, 0)))
>  			die("failure: create");
>  
>  		/* create symlink */
> @@ -734,6 +735,7 @@ out:
>  /* Validate that changing file ownership works correctly on idmapped mounts. */
>  int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  {
> +	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
>  	int fret = -1;
>  	int file1_fd = -EBADF, open_tree_fd1 = -EBADF, open_tree_fd2 = -EBADF;
>  	struct mount_attr attr1 = {
> @@ -763,7 +765,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  	}
>  
>  	/* create character device */
> -	if (mknodat(info->t_dir1_fd, CHRDEV1, S_IFCHR | 0644, makedev(0, 0))) {
> +	if (whiteout_dev && mknodat(info->t_dir1_fd, CHRDEV1, S_IFCHR | 0644, makedev(0, 0))) {
>  		log_stderr("failure: mknodat");
>  		goto out;
>  	}
> @@ -824,7 +826,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> -	if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 0, 0)) {
> +	if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 0, 0)) {
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> @@ -856,7 +858,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> -	if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 10000, 10000)) {
> +	if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 10000, 10000)) {
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> @@ -911,7 +913,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> -	if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 30000, 30000)) {
> +	if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 30000, 30000)) {
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> @@ -941,7 +943,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: fchownat");
>  		goto out;
>  	}
> -	if (fchownat(info->t_dir1_fd, CHRDEV1, 2000, 2000, 0)) {
> +	if (whiteout_dev && fchownat(info->t_dir1_fd, CHRDEV1, 2000, 2000, 0)) {
>  		log_stderr("failure: fchownat");
>  		goto out;
>  	}
> @@ -971,7 +973,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> -	if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 2000, 2000)) {
> +	if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 2000, 2000)) {
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> @@ -1001,7 +1003,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> -	if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 12000, 12000)) {
> +	if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 12000, 12000)) {
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> @@ -1031,7 +1033,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> -	if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 32000, 32000)) {
> +	if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 32000, 32000)) {
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> @@ -1063,7 +1065,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  			die("failure: fchownat");
>  		if (!fchownat(info->t_dir1_fd, HARDLINK1, 1000, 1000, 0))
>  			die("failure: fchownat");
> -		if (!fchownat(info->t_dir1_fd, CHRDEV1, 1000, 1000, 0))
> +		if (whiteout_dev && !fchownat(info->t_dir1_fd, CHRDEV1, 1000, 1000, 0))
>  			die("failure: fchownat");
>  		if (!fchownat(info->t_dir1_fd, SYMLINK1, 2000, 2000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
>  			die("failure: fchownat");
> @@ -1078,7 +1080,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  			die("failure: fchownat");
>  		if (!fchownat(open_tree_fd2, HARDLINK1, 1000, 1000, 0))
>  			die("failure: fchownat");
> -		if (!fchownat(open_tree_fd2, CHRDEV1, 1000, 1000, 0))
> +		if (whiteout_dev && !fchownat(open_tree_fd2, CHRDEV1, 1000, 1000, 0))
>  			die("failure: fchownat");
>  		if (!fchownat(open_tree_fd2, SYMLINK1, 2000, 2000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
>  			die("failure: fchownat");
> @@ -1093,7 +1095,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  			die("failure: fchownat");
>  		if (fchownat(open_tree_fd1, HARDLINK1, 1000, 1000, 0))
>  			die("failure: fchownat");
> -		if (fchownat(open_tree_fd1, CHRDEV1, 1000, 1000, 0))
> +		if (whiteout_dev && fchownat(open_tree_fd1, CHRDEV1, 1000, 1000, 0))
>  			die("failure: fchownat");
>  		if (fchownat(open_tree_fd1, SYMLINK1, 2000, 2000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
>  			die("failure: fchownat");
> @@ -1108,7 +1110,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  			die("failure: expected_uid_gid");
>  		if (!expected_uid_gid(info->t_dir1_fd, HARDLINK1, 0, info->t_overflowuid, info->t_overflowgid))
>  			die("failure: expected_uid_gid");
> -		if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
> +		if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
>  			die("failure: expected_uid_gid");
>  		if (!expected_uid_gid(info->t_dir1_fd, SYMLINK1, AT_SYMLINK_NOFOLLOW, info->t_overflowuid, info->t_overflowgid))
>  			die("failure: expected_uid_gid");
> @@ -1123,7 +1125,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  			die("failure: expected_uid_gid");
>  		if (!expected_uid_gid(open_tree_fd2, HARDLINK1, 0, info->t_overflowuid, info->t_overflowgid))
>  			die("failure: expected_uid_gid");
> -		if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
>  			die("failure: expected_uid_gid");
>  		if (!expected_uid_gid(open_tree_fd2, SYMLINK1, AT_SYMLINK_NOFOLLOW, info->t_overflowuid, info->t_overflowgid))
>  			die("failure: expected_uid_gid");
> @@ -1138,7 +1140,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  			die("failure: expected_uid_gid");
>  		if (!expected_uid_gid(open_tree_fd1, HARDLINK1, 0, 1000, 1000))
>  			die("failure: expected_uid_gid");
> -		if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 1000, 1000))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 1000, 1000))
>  			die("failure: expected_uid_gid");
>  		if (!expected_uid_gid(open_tree_fd1, SYMLINK1, AT_SYMLINK_NOFOLLOW, 2000, 2000))
>  			die("failure: expected_uid_gid");
> @@ -1166,7 +1168,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> -	if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 1000, 1000)) {
> +	if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 1000, 1000)) {
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> @@ -1196,7 +1198,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> -	if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 11000, 11000)) {
> +	if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 11000, 11000)) {
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> @@ -1226,7 +1228,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> -	if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 31000, 31000)) {
> +	if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 31000, 31000)) {
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> @@ -1258,7 +1260,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  			die("failure: fchownat");
>  		if (!fchownat(info->t_dir1_fd, HARDLINK1, 0, 0, 0))
>  			die("failure: fchownat");
> -		if (!fchownat(info->t_dir1_fd, CHRDEV1, 0, 0, 0))
> +		if (whiteout_dev && !fchownat(info->t_dir1_fd, CHRDEV1, 0, 0, 0))
>  			die("failure: fchownat");
>  		if (!fchownat(info->t_dir1_fd, SYMLINK1, 3000, 3000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
>  			die("failure: fchownat");
> @@ -1273,7 +1275,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  			die("failure: fchownat");
>  		if (!fchownat(open_tree_fd1, HARDLINK1, 0, 0, 0))
>  			die("failure: fchownat");
> -		if (!fchownat(open_tree_fd1, CHRDEV1, 0, 0, 0))
> +		if (whiteout_dev && !fchownat(open_tree_fd1, CHRDEV1, 0, 0, 0))
>  			die("failure: fchownat");
>  		if (!fchownat(open_tree_fd1, SYMLINK1, 3000, 3000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
>  			die("failure: fchownat");
> @@ -1288,7 +1290,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  			die("failure: fchownat");
>  		if (fchownat(open_tree_fd2, HARDLINK1, 0, 0, 0))
>  			die("failure: fchownat");
> -		if (fchownat(open_tree_fd2, CHRDEV1, 0, 0, 0))
> +		if (whiteout_dev && fchownat(open_tree_fd2, CHRDEV1, 0, 0, 0))
>  			die("failure: fchownat");
>  		if (!fchownat(open_tree_fd2, SYMLINK1, 3000, 3000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
>  			die("failure: fchownat");
> @@ -1303,7 +1305,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  			die("failure: expected_uid_gid");
>  		if (!expected_uid_gid(info->t_dir1_fd, HARDLINK1, 0, info->t_overflowuid, info->t_overflowgid))
>  			die("failure: expected_uid_gid");
> -		if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
> +		if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
>  			die("failure: expected_uid_gid");
>  		if (!expected_uid_gid(info->t_dir1_fd, SYMLINK1, AT_SYMLINK_NOFOLLOW, info->t_overflowuid, info->t_overflowgid))
>  			die("failure: expected_uid_gid");
> @@ -1318,7 +1320,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  			die("failure: expected_uid_gid");
>  		if (!expected_uid_gid(open_tree_fd1, HARDLINK1, 0, info->t_overflowuid, info->t_overflowgid))
>  			die("failure: expected_uid_gid");
> -		if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
>  			die("failure: expected_uid_gid");
>  		if (!expected_uid_gid(open_tree_fd1, SYMLINK1, AT_SYMLINK_NOFOLLOW, info->t_overflowuid, info->t_overflowgid))
>  			die("failure: expected_uid_gid");
> @@ -1333,7 +1335,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  			die("failure: expected_uid_gid");
>  		if (!expected_uid_gid(open_tree_fd2, HARDLINK1, 0, 0, 0))
>  			die("failure: expected_uid_gid");
> -		if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 0, 0))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 0, 0))
>  			die("failure: expected_uid_gid");
>  		if (!expected_uid_gid(open_tree_fd2, SYMLINK1, AT_SYMLINK_NOFOLLOW, 2000, 2000))
>  			die("failure: expected_uid_gid");
> @@ -1361,7 +1363,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> -	if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 0, 0)) {
> +	if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 0, 0)) {
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> @@ -1391,7 +1393,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> -	if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 10000, 10000)) {
> +	if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 10000, 10000)) {
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> @@ -1421,7 +1423,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> -	if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 30000, 30000)) {
> +	if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 30000, 30000)) {
>  		log_stderr("failure: expected_uid_gid");
>  		goto out;
>  	}
> @@ -3781,6 +3783,7 @@ out:
>  
>  int tcore_setgid_create_idmapped(const struct vfstest_info *info)
>  {
> +	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
>  	int fret = -1;
>  	int file1_fd = -EBADF, open_tree_fd = -EBADF;
>  	struct mount_attr attr = {
> @@ -3881,10 +3884,10 @@ int tcore_setgid_create_idmapped(const struct vfstest_info *info)
>  			die("failure: is_setgid");
>  
>  		/* create a whiteout device via mknodat() vfs_mknod */
> -		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
> +		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
>  			die("failure: mknodat");
>  
> -		if (is_setgid(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_setgid");
>  
>  		/*
> @@ -3906,7 +3909,7 @@ int tcore_setgid_create_idmapped(const struct vfstest_info *info)
>  		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 10000, 10000))
>  			die("failure: check ownership");
>  
> -		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
>  			die("failure: check ownership");
>  
>  		if (unlinkat(open_tree_fd, FILE1, 0))
> @@ -3918,7 +3921,7 @@ int tcore_setgid_create_idmapped(const struct vfstest_info *info)
>  		if (unlinkat(open_tree_fd, FILE2, 0))
>  			die("failure: delete");
>  
> -		if (unlinkat(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
>  			die("failure: delete");
>  
>  		/* create tmpfile via filesystem tmpfile api */
> @@ -3957,6 +3960,7 @@ out:
>  
>  int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
>  {
> +	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
>  	int fret = -1;
>  	int file1_fd = -EBADF, open_tree_fd = -EBADF;
>  	struct mount_attr attr = {
> @@ -4051,10 +4055,10 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
>  			die("failure: is_setgid");
>  
>  		/* create a whiteout device via mknodat() vfs_mknod */
> -		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
> +		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
>  			die("failure: mknodat");
>  
> -		if (!is_setgid(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && !is_setgid(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_setgid");
>  
>  		if (!expected_uid_gid(open_tree_fd, FILE1, 0, 0, 0))
> @@ -4066,7 +4070,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
>  		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 0))
>  			die("failure: check ownership");
>  
> -		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 0))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 0))
>  			die("failure: check ownership");
>  
>  		if (unlinkat(open_tree_fd, FILE1, 0))
> @@ -4078,7 +4082,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
>  		if (unlinkat(open_tree_fd, FILE2, 0))
>  			die("failure: delete");
>  
> -		if (unlinkat(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
>  			die("failure: delete");
>  
>  		/* create tmpfile via filesystem tmpfile api */
> @@ -4168,10 +4172,10 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
>  			die("failure: is_setgid");
>  
>  		/* create a whiteout device via mknodat() vfs_mknod */
> -		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
> +		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
>  			die("failure: mknodat");
>  
> -		if (is_setgid(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_setgid");
>  
>  		/*
> @@ -4193,7 +4197,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
>  		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 1000))
>  			die("failure: check ownership");
>  
> -		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
>  			die("failure: check ownership");
>  
>  		if (unlinkat(open_tree_fd, FILE1, 0))
> @@ -4205,7 +4209,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
>  		if (unlinkat(open_tree_fd, FILE2, 0))
>  			die("failure: delete");
>  
> -		if (unlinkat(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
>  			die("failure: delete");
>  
>  		/* create tmpfile via filesystem tmpfile api */
> @@ -4293,10 +4297,10 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
>  			die("failure: is_setgid");
>  
>  		/* create a whiteout device via mknodat() vfs_mknod */
> -		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
> +		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
>  			die("failure: mknodat");
>  
> -		if (is_setgid(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_setgid");
>  
>  		if (!expected_uid_gid(open_tree_fd, FILE1, 0, 0, 0))
> @@ -4308,7 +4312,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
>  		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 0))
>  			die("failure: check ownership");
>  
> -		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 0))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 0))
>  			die("failure: check ownership");
>  
>  		if (unlinkat(open_tree_fd, FILE1, 0))
> @@ -4320,7 +4324,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
>  		if (unlinkat(open_tree_fd, FILE2, 0))
>  			die("failure: delete");
>  
> -		if (unlinkat(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
>  			die("failure: delete");
>  
>  		/* create tmpfile via filesystem tmpfile api */
> @@ -7675,6 +7679,7 @@ out:
>   */
>  static int setgid_create_umask_idmapped(const struct vfstest_info *info)
>  {
> +	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
>  	int fret = -1;
>  	int file1_fd = -EBADF, open_tree_fd = -EBADF;
>  	struct mount_attr attr = {
> @@ -7793,13 +7798,13 @@ static int setgid_create_umask_idmapped(const struct vfstest_info *info)
>  			die("failure: is_ixgrp");
>  
>  		/* create a whiteout device via mknodat() vfs_mknod */
> -		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
> +		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
>  			die("failure: mknodat");
>  
> -		if (is_setgid(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_setgid");
>  
> -		if (is_ixgrp(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_ixgrp(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_ixgrp");
>  
>  		/*
> @@ -7821,7 +7826,7 @@ static int setgid_create_umask_idmapped(const struct vfstest_info *info)
>  		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 10000, 10000))
>  			die("failure: check ownership");
>  
> -		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
>  			die("failure: check ownership");
>  
>  		if (unlinkat(open_tree_fd, FILE1, 0))
> @@ -7833,7 +7838,7 @@ static int setgid_create_umask_idmapped(const struct vfstest_info *info)
>  		if (unlinkat(open_tree_fd, FILE2, 0))
>  			die("failure: delete");
>  
> -		if (unlinkat(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
>  			die("failure: delete");
>  
>  		/* create tmpfile via filesystem tmpfile api */
> @@ -7889,6 +7894,7 @@ out:
>   */
>  static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *info)
>  {
> +	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
>  	int fret = -1;
>  	int file1_fd = -EBADF, open_tree_fd = -EBADF;
>  	struct mount_attr attr = {
> @@ -8028,13 +8034,13 @@ static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *inf
>  			die("failure: is_ixgrp");
>  
>  		/* create a whiteout device via mknodat() vfs_mknod */
> -		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
> +		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
>  			die("failure: mknodat");
>  
> -		if (is_setgid(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_setgid");
>  
> -		if (is_ixgrp(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_ixgrp(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_ixgrp");
>  
>  		/*
> @@ -8056,7 +8062,7 @@ static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *inf
>  		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 1000))
>  			die("failure: check ownership");
>  
> -		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
>  			die("failure: check ownership");
>  
>  		if (unlinkat(open_tree_fd, FILE1, 0))
> @@ -8068,7 +8074,7 @@ static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *inf
>  		if (unlinkat(open_tree_fd, FILE2, 0))
>  			die("failure: delete");
>  
> -		if (unlinkat(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
>  			die("failure: delete");
>  
>  		/* create tmpfile via filesystem tmpfile api */
> @@ -8123,6 +8129,7 @@ out:
>   */
>  static int setgid_create_acl_idmapped(const struct vfstest_info *info)
>  {
> +	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
>  	int fret = -1;
>  	int file1_fd = -EBADF, open_tree_fd = -EBADF;
>  	struct mount_attr attr = {
> @@ -8248,13 +8255,13 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
>  			die("failure: is_ixgrp");
>  
>  		/* create a whiteout device via mknodat() vfs_mknod */
> -		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
> +		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
>  			die("failure: mknodat");
>  
> -		if (is_setgid(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_setgid");
>  
> -		if (is_ixgrp(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_ixgrp(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_ixgrp");
>  
>  		/*
> @@ -8276,7 +8283,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
>  		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 10000, 10000))
>  			die("failure: check ownership");
>  
> -		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
>  			die("failure: check ownership");
>  
>  		if (unlinkat(open_tree_fd, FILE1, 0))
> @@ -8288,7 +8295,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
>  		if (unlinkat(open_tree_fd, FILE2, 0))
>  			die("failure: delete");
>  
> -		if (unlinkat(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
>  			die("failure: delete");
>  
>  		/* create tmpfile via filesystem tmpfile api */
> @@ -8383,13 +8390,13 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
>  			die("failure: is_ixgrp");
>  
>  		/* create a whiteout device via mknodat() vfs_mknod */
> -		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
> +		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
>  			die("failure: mknodat");
>  
> -		if (is_setgid(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_setgid");
>  
> -		if (!is_ixgrp(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && !is_ixgrp(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_ixgrp");
>  
>  		/*
> @@ -8411,7 +8418,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
>  		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 10000, 10000))
>  			die("failure: check ownership");
>  
> -		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
>  			die("failure: check ownership");
>  
>  		if (unlinkat(open_tree_fd, FILE1, 0))
> @@ -8423,7 +8430,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
>  		if (unlinkat(open_tree_fd, FILE2, 0))
>  			die("failure: delete");
>  
> -		if (unlinkat(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
>  			die("failure: delete");
>  
>  		/* create tmpfile via filesystem tmpfile api */
> @@ -8478,6 +8485,7 @@ out:
>   */
>  static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
>  {
> +	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
>  	int fret = -1;
>  	int file1_fd = -EBADF, open_tree_fd = -EBADF;
>  	struct mount_attr attr = {
> @@ -8624,13 +8632,13 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
>  			die("failure: is_ixgrp");
>  
>  		/* create a whiteout device via mknodat() vfs_mknod */
> -		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
> +		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
>  			die("failure: mknodat");
>  
> -		if (is_setgid(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_setgid");
>  
> -		if (is_ixgrp(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_ixgrp(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_ixgrp");
>  
>  		/*
> @@ -8652,7 +8660,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
>  		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 1000))
>  			die("failure: check ownership");
>  
> -		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
>  			die("failure: check ownership");
>  
>  		if (unlinkat(open_tree_fd, FILE1, 0))
> @@ -8664,7 +8672,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
>  		if (unlinkat(open_tree_fd, FILE2, 0))
>  			die("failure: delete");
>  
> -		if (unlinkat(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
>  			die("failure: delete");
>  
>  		/* create tmpfile via filesystem tmpfile api */
> @@ -8766,13 +8774,13 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
>  		if (!is_ixgrp(open_tree_fd, FILE2, 0))
>  			 die("failure: is_ixgrp");
>  		/* create a whiteout device via mknodat() vfs_mknod */
> -		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
> +		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
>  			die("failure: mknodat");
>  
> -		if (is_setgid(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
>  			die("failure: is_setgid");
>  
> -		if (!is_ixgrp(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && !is_ixgrp(open_tree_fd, CHRDEV1, 0))
>  			 die("failure: is_ixgrp");
>  
>  		/*
> @@ -8794,7 +8802,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
>  		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 1000))
>  			die("failure: check ownership");
>  
> -		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
> +		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
>  			die("failure: check ownership");
>  
>  		if (unlinkat(open_tree_fd, FILE1, 0))
> @@ -8806,7 +8814,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
>  		if (unlinkat(open_tree_fd, FILE2, 0))
>  			die("failure: delete");
>  
> -		if (unlinkat(open_tree_fd, CHRDEV1, 0))
> +		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
>  			die("failure: delete");
>  
>  		/* create tmpfile via filesystem tmpfile api */
> diff --git a/src/vfs/utils.c b/src/vfs/utils.c
> index 0b435afe..0094adc3 100644
> --- a/src/vfs/utils.c
> +++ b/src/vfs/utils.c
> @@ -955,6 +955,31 @@ bool openat_tmpfile_supported(int dirfd)
>  	return true;
>  }
>  
> +/*
> + * A 0:0 character device is the only device node an unprivileged caller may
> + * create, so the idmapped mount tests use one as a fixture. overlayfs reserves
> + * that dev_t as its whiteout marker and ovl_mknod() rejects it with EPERM.
> + * Probe on the base mount as the filesystem owner so a filesystem that later
> + * allows the node keeps the coverage. Any error other than EPERM is reported.
> + */
> +bool whiteout_device_supported(int dirfd)
> +{
> +	static const char name[] = ".whiteout_probe";
> +
> +	if (!mknodat(dirfd, name, S_IFCHR | 0644, makedev(0, 0))) {
> +		if (unlinkat(dirfd, name, 0))
> +			return log_errno(false, "failure: unlinkat");
> +		return true;
> +	}
> +
> +	if (errno == EPERM) {
> +		errno = 0;
> +		return false;
> +	}
> +
> +	return log_errno(false, "failure: mknodat");
> +}
> +
>  /*
>   * There'll be scenarios where you'll want to see the attributes associated with
>   * a directory tree during debugging or just to make sure things look correct.
> diff --git a/src/vfs/utils.h b/src/vfs/utils.h
> index c086885a..41b2f499 100644
> --- a/src/vfs/utils.h
> +++ b/src/vfs/utils.h
> @@ -372,5 +372,6 @@ extern bool is_setgid(int dfd, const char *path, int flags);
>  extern bool is_sticky(int dfd, const char *path, int flags);
>  extern bool is_ixgrp(int dfd, const char *path, int flags);
>  extern bool openat_tmpfile_supported(int dirfd);
> +extern bool whiteout_device_supported(int dirfd);
>  
>  #endif /* __IDMAP_UTILS_H */
> -- 
> 2.55.0
> 
> 
