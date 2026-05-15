Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810AF33C507
	for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 13:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778850971; cv=none; b=FEBHsqnLSu2i48MqxxxUqrB4mUh3naUSmpC/rWjLo9bcW3hJEPUTwsbER5Sv9Std9Z7zqEpzwKI6Ie+NFJp/FEJ35MTWuo5ebjuBMKOjMpP2hxqe/GYRKUW8DpkBF/yM3uFoVkFhxykvEjueNYmlxITv2if8myvd6msgoiCNxzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778850971; c=relaxed/simple;
	bh=gCN8P3MUhHuEAAga0c668OJad0aeblJzx49m6gKQxp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vDUqMw4fHWGkDEie+2iqtI2wBiAr8Pmo/Vcwtcyjyd/yq74VWGFE7i62logDoX+Iab6lkR3DFiFimp4Z8f4eX0cHgLAIpZ0DZTbkIPTJB0U0lCqAMiiNN25srh+1/D1ZTO7RNaXzmLkiGAg+unwPccXkvd/TSRnPA8hXlXCgPRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=i2ChIKbX; arc=none smtp.client-ip=195.121.94.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="i2ChIKbX"
X-KPN-MessageId: 36d1a624-5060-11f1-bea8-005056992ed3
Received: from smtp.kpnmail.nl (unknown [10.31.155.6])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 36d1a624-5060-11f1-bea8-005056992ed3;
	Fri, 15 May 2026 15:15:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=YqBvR82qpMxVqnzfYcEzPa+qPxOXrNcw1h3a/uDTzLI=;
	b=i2ChIKbXPRvOqVw5+fOKl/+mB8veAfAwqG5e0JPZNsJRi0LJFIm1QEBhPbvPEKplzjxmSmFKqcqCs
	 +YbyfxzwuCLRTAqQCJxw3znYdp0WptBAvkAHL3yiUcShGbmNSW1STeH5Nk5rRhIJZNjSAV5KJ4iJaN
	 djgBfDjTtOBtnOf/r1mdZ0m5WXbXjG/Rd4Sf0M8AGgNUdqt2ocQCqPp/5I6w59cdaGRcVlYwaysYfM
	 CovS2zmZXnWqJ3wdxLuZNeYfW419R/ZkJizZ90TEdT6hon3orjYoPMz+9aC385zwzyghHXAyHB/wEx
	 IF4vMvD0tGZv2Nhacybg4HhwDfv2AFw==
X-KPN-MID: 33|cF02uNPZbcyFC5ZXtO1GC+lE3eB5mIyAJbtqZ/vnX40H64jt2iI7eR1p0VNdJHN
 OKIa4RduM4ZEwdPVexzDFzNWc+jXeqtXMMjG8fY734TE=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|JRUSPe5P8CHBdf1RfUK7YhPBIOZU79IKzzkabRGbatWFGj4gjZe7LXMUHSPfPgf
 47dz4+0IvAx0VNmmyLSQ52g==
Received: from localhost (unknown [178.226.150.234])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 36b2b2e6-5060-11f1-bffb-00505699772e;
	Fri, 15 May 2026 15:15:59 +0200 (CEST)
Date: Fri, 15 May 2026 15:15:53 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nirmoy Das <nirmoyd@nvidia.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
Message-ID: <agcXkoKekkAJ1-8z@lt-jori.localdomain>
Mail-Followup-To: Jori Koolstra <jkoolstra@xs4all.nl>, 
	Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nirmoy Das <nirmoyd@nvidia.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260514200129.94862-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514200129.94862-1-amir73il@gmail.com>

On Thu, May 14, 2026 at 10:01:29PM +0200, Amir Goldstein wrote:
> Code using ERR_PTR() is almost certainly intending to produce a value
> which qualified as IS_ERR_OR_NULL(), but this is not the case when
> code calls ERR_PTR(err) with positive or large negative err.
> 
> Introduce a fortified variant of ERR_PTR() whose return value is
> guaranteed to qualify as IS_ERR_OR_NULL().
> 
> We add this in a new header file err_ptr.h which includes bug.h
> for the build/run time assertions.
> 
> Subsystems may opt-in for fortified ERR_PTR() for specific call sites
> or by #define ERR_PTR(err) ERR_PTR_SAFE(err).
> 
> Link: https://lore.kernel.org/r/CAOQ4uxg=gONUh5QEW5KJcyXLDF15HbLnc9Ea7RKPcgtyfPasTA@mail.gmail.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 

This seems like a good idea. Perhaps, we should also not pass error
pointers as parameters. It just invites similar issues. For example,
in

	if (!error) {
		dentry = vfs_mkdir(mnt_idmap(path.mnt), path.dentry->d_inode,
				   dentry, mode, &delegated_inode);
		if (IS_ERR(dentry))
			error = PTR_ERR(dentry);
	}
	end_creating_path(&path, dentry);

Suppose you want to make changes to end_creating_path, nothing indicates
that dentry may hold an error here. In this case it is not too hard to
find out, but it seems like a bad idea in general. But I might miss
cases where this is really useful... :)


> Guys,
> 
> Please follow the Link to see the sneaky bug that Nirmoy tracked down.
> syzbot has complained about this a while ago, but neither me nor my AI
> helpers were able to track it down from code analysis.
> 
> Honestly, with AI review, this class of bugs (return a stale err value)
> should not be happening anymore, but it annoyed me that ERR_PTR() can
> return a value which is not an IS_ERR(). It messes with code flow
> analysis.
> 
> What do you think about this macro?
> 
> I intend to #define ERR_PTR(err) ERR_PTR_SAFE(err) in overlayfs.h
> to fortify all of the ERR_PTR() in overlayfs code.
> 
> What do you think about this opt-in method?
> Any reason to make this more widespread by default?
> 
> Thanks,
> Amir.
> 
> 
>  include/linux/err_ptr.h | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 include/linux/err_ptr.h
> 
> diff --git a/include/linux/err_ptr.h b/include/linux/err_ptr.h
> new file mode 100644
> index 0000000000000..829ec5f771528
> --- /dev/null
> +++ b/include/linux/err_ptr.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_ERR_PTR_H
> +#define _LINUX_ERR_PTR_H
> +
> +#include <linux/err.h>
> +#include <linux/bug.h>
> +
> +/**
> + * ERR_PTR_SAFE - Create an error pointer, with validation.
> + * @error: An error code to encode as an error pointer.
> + *
> + * Like ERR_PTR(), but validates @error:
> + * - For constant @error: fails the build if the value is not a valid errno
> + *   (zero is allowed, producing NULL).
> + * - For variable @error: warns and clamps to -MAX_ERRNO if out of range.
> + *
> + * Subsystems may opt in for all ERR_PTR() call sites by adding after includes:
> + *   #undef ERR_PTR
> + *   #define ERR_PTR(err) ERR_PTR_SAFE(err)
> + */
> +#define ERR_PTR_SAFE(error) ({						\
> +	long __e = (error);						\
> +	if (__builtin_constant_p(__e))					\
> +		BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));		\
> +	__builtin_constant_p(__e) ? (void *)__e :			\
> +		(void *)(WARN_ON(__e && !IS_ERR_VALUE(__e)) ? -MAX_ERRNO : __e);\
> +})
> +
> +#endif /* _LINUX_ERR_PTR_H */
> -- 
> 2.54.0
> 
