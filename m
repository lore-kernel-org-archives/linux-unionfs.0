Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7379A23B0
	for <linux-unionfs@vger.kernel.org>; Fri, 24 Jan 2025 11:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737716790; cv=none; b=E48K9JSBHxvJkduLugxBTh8hoiqHANjzeX0yOM/C8nY4BFdA05GiTQp80QbHmveuREEgJO34Vv9WEiNYHhMtodWEKYlyPSC/Ctlz/tJjXBcp68oli7Oujr/wBnBKiG5QbV5sac64Mqdabw+hEmI1VQ0aEyMTRlkOX4mzn2gGkGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737716790; c=relaxed/simple;
	bh=RAhgG3qZOZ7hXBOrfxJfJaEgPvC3LZ9/k4FWTueqbrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T3B+c+r9d0knWzDeGEN88HMEaZySwQrOOfv8ru1oVFT+YizmSsJGxXlcHD50G02bhWeuTCkxJBO2dV4SPvf6usQHuSolfLxzD0bt3CFCTtnIRw7kmB04H1SNZ1q0rA1TT9yfkizXX3WF2XpFgv7Nv1Cy47sOHolJZzJCRvyghUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xg/fu3/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xg/fu3/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2007C4CED2;
	Fri, 24 Jan 2025 11:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737716789;
	bh=RAhgG3qZOZ7hXBOrfxJfJaEgPvC3LZ9/k4FWTueqbrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xg/fu3/s3wgIMeBhE5fInRaJbeBIYhV9CYsJvRpCX7zad4Op78DMvP+WOrfnI0Me+
	 FR3Z96YB1+RvzJ9XF3/XztMIudqgQyA+Rj0lLfb/onOqO6EM0ZDSZYPemle3Kzhy+9
	 xqqjGtz6z01Ww1j6R8dTsWQznY4SCU1iAno5hGSc4ZXMjRxshQgSK5iG+IZ06Lgy+D
	 nYMnGayy3nV7QwsSECnKLgxfYOte83tgE7WMkqX5lmZqlCFV5XxWx7Kuk+vOX0wfE7
	 yNNYWX5OZNvdL0TJX6OOXevTimkL9EQcnRLbhPeOprLPujukK0JhNXIUv8SdIl0yeY
	 DsKrt/UdVExig==
Date: Fri, 24 Jan 2025 12:06:26 +0100
From: Christian Brauner <brauner@kernel.org>
To: Mike Baynton <mike@mbaynton.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: ovl: Allow layers from anonymous mount namespaces?
Message-ID: <20250124-daran-achten-154ca16111cb@brauner>
References: <fd8f6574-f737-4743-b220-79c815ee1554@mbaynton.com>
 <20250123-senkung-spangen-c0aabc251c65@brauner>
 <e7733291-48a4-4b65-bbdb-8462b9708af9@mbaynton.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e7733291-48a4-4b65-bbdb-8462b9708af9@mbaynton.com>

On Thu, Jan 23, 2025 at 11:40:41PM -0600, Mike Baynton wrote:
> On 1/23/25 13:21, Christian Brauner wrote:
> > On Wed, Jan 22, 2025 at 10:18:17PM -0600, Mike Baynton wrote:
> >> Hi,
> >> I've been eagerly awaiting the arrival of lowerdir+ by file handle, as
> >> it looks likely to be well-suited to simplifying the task a container
> >> runtime must take on in order to provide a set of properly idmapped
> >> lower layers for a user namespaced container. Currently in containerd,
> >> this is done by creating bindmounts for each required lower layer in
> >> order to apply idmapping to them. Each of these bindmounts must be
> >> briefly attached to some path-resolvable mountpoint before the overlay
> >> is created, which seems less than ideal and is contributing to some
> >> cleanup headaches e.g. when other software that may be present jumps on
> >> the new mount and starts security scanning it or whatnot.
> >>
> >> In order to better isolate the idmap bindmounts I was hoping to do
> >> something like:
> >>
> >> ovl_ctx = fsopen("overlay", FSOPEN_CLOEXEC);
> >>
> >> opfd = open_tree(-1, "/path/to/unmapped/layer",
> >> OPEN_TREE_CLONE|OPEN_TREE_CLOEXEC);
> >> mount_setattr(opfd, "", AT_EMPTY_PATH, /* attrs to set a userns_fd */);
> >> dfd = openat(opfd, ".", O_DIRECTORY, mode);
> > 
> > Unless I forgot detaile, openat() shouldn't be needed as speciyfing
> > layers via O_PATH file descriptors should just work.
> 
> O_PATH ones currently result in EBADF, iirc just because fsconfig with
> FSCONFIG_SET_FD looks up the file descriptor in a way that masks O_PATH.
> This took some time to work out too, but doesn't strike me as a huge
> deal. Although I suppose it's one of those things that if it were
> improved far down the road would probably lead to next to nobody
> removing the openat().

Oh right. We should be able to enable FSONFIG_SET_FD to accept O_PATH
file descriptors. To not break existing users we need do introduce:

diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 4b4bfef6f053..e160e7c61e4b 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -55,6 +55,7 @@ enum fs_value_type {
        fs_value_is_blob,               /* Value is a binary blob */
        fs_value_is_filename,           /* Value is a filename* + dirfd */
        fs_value_is_file,               /* Value is a file* */
+       fs_value_is_file_fmode_path,    /* Value is a file* */
 };

 /*
diff --git a/include/linux/fs_parser.h b/include/linux/fs_parser.h
index 3cef566088fc..17ba4951298b 100644
--- a/include/linux/fs_parser.h
+++ b/include/linux/fs_parser.h
@@ -134,6 +134,7 @@ static inline bool fs_validate_description(const char *name,
 #define fsparam_bdev(NAME, OPT)        __fsparam(fs_param_is_blockdev, NAME, OPT, 0, NULL)
 #define fsparam_path(NAME, OPT)        __fsparam(fs_param_is_path, NAME, OPT, 0, NULL)
 #define fsparam_fd(NAME, OPT)  __fsparam(fs_param_is_fd, NAME, OPT, 0, NULL)
+#define fsparam_path_fd(NAME, OPT)     __fsparam(fs_param_is_path_fd, NAME, OPT, 0, NULL)
 #define fsparam_file_or_string(NAME, OPT) \
                                __fsparam(fs_param_is_file_or_string, NAME, OPT, 0, NULL)
 #define fsparam_uid(NAME, OPT) __fsparam(fs_param_is_uid, NAME, OPT, 0, NULL)

and so that we don't break code and autofs FSCONFIG_SET_FD usage. Both
want non O_PATH fds. But otherwise I don't see an issue with this.
