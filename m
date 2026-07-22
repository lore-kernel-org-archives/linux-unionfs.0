Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51747083C;
	Wed, 22 Jul 2026 14:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784730345; cv=none; b=Zu7Q/N68c4VXgle83q5oyAuZzsgAAmlLdUulX1g5KwbIK9r6nhDB4J7Gmcc3xe6WlipODUNMa+By1WSqqOL/HR8bvi4OsEk949giMwjt4/+vECh07NyadZewoUzH+0JEQSAurYwhu4+cUpxRH0b3JE+v18sjR24FqR+u3S80828=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784730345; c=relaxed/simple;
	bh=x5OLo4YTWLIOMETrnu2IZQMFHkb9oKa0hKDXoZmkJ9E=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=nhePJDHxXtLEoHDDmEBhL7piDO8AXjE8LUqHQccTH7jCph2RyQvsk++A9D0kEoW+eYR0pat+ZzOyuUhslzdTS7VFmzUExilrBEviZBvjQQV6aLiTkZdxxiZN6fNF77y4BX1GQKNym+jvBYb6AyKN3xVtG2uRoQHiIfRsqThQPSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mn9EOVCA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mn9EOVCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7811F000E9;
	Wed, 22 Jul 2026 14:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784730344;
	bh=MB2674Xq9iUX2pckuew3NqZMSr8/d8+HLDJJQm6Smho=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Mn9EOVCAzHILrLnIRFbI/FT9YSc7lEimRoN2Rnq0bCq2CB3Yrm0nAh9KD7OaJc4K1
	 T0tQWhE6SUvOApZBKJWFs43mRBZjwJ3Y2DLVuAWnQTXZc1+Iywul5Ev4KBWBAifOi1
	 0hHakJMTDOL3wyN3EWuuKTN5FP7Ku5LcD12BR6/XAFkPIyQ76fZVdHX8h5Uv/EPREp
	 nP8OcAOi+MFabL2DU3EKm7BnkHzDAWwEbzIAFMfoBQqrgV+qpFchIvJZTUtki/JmhY
	 R4Y9kceUWZq3/Ax5d/LTt/hcrwujq7WFxEUTzufZEawYAppfHf8HRGH0RJR1FR0MEE
	 iJLA2DJNSTYzQ==
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through
 O_ALT
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Lutomirski <luto@amacapital.net>, 
 Miklos Szeredi <mszeredi@redhat.com>, 
 Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
 linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
 linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
 Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAJfpeguxCOw4cURjPVOMj5-A7JnLrmy8zx4qE9uwxg7x_Wr+zg@mail.gmail.com>
References: <20260715101107.973997-1-mszeredi@redhat.com>
 <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
 <CAJfpeguxCOw4cURjPVOMj5-A7JnLrmy8zx4qE9uwxg7x_Wr+zg@mail.gmail.com>
Date: Wed, 22 Jul 2026 16:25:39 +0200
Message-Id: <20260722-erraten-hinblick-erlesen-2520fd1a3726@brauner>
X-Mailer: b4 0.16-dev-2f6f2
X-Developer-Signature: v=1; a=openpgp-sha256; l=774; i=brauner@kernel.org;
 h=from:subject:message-id; bh=x5OLo4YTWLIOMETrnu2IZQMFHkb9oKa0hKDXoZmkJ9E=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlXHrqYplk+av8ybQPod1+C22T9/E9742v7JvsGnVaK
 PURn4djRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQ4uRj+ys5333Noi32U0oyG
 5vsm9q8NbiUeaol/ePmyQdo1/2XnGhj+B/HNPysa0Kf5RSChfwXXLIH951XVz28TjZ0VeCHy8ux
 d/AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-20 11:22 +0200, Miklos Szeredi wrote:
> On Sun, 19 Jul 2026 at 16:13, Andy Lutomirski <luto@amacapital.net> wrote:
> 
> > This gives me the willies a bit.  It's very cool, but it has some
> > potential security issues that I think we need to watch out for.  As
> > sort-of prior art, NTFS supports alternate streams and Reiser4, ahem,
> > supported files-as-directories.
> 
> I realized that we can keep the creepiness factor minimal by
> introducing this first in procfs only.   That way zero changes are
> needed in the path lookup code:
> 
> sprintf(buf, "/proc/self/fd-alt/%d/%s", base_fd, alt_path);
> alt_fd = open(buf, O_PATH);

I'm still vehemently opposed to stuffing more creepy apis into procfs.
So this gets clear opposition from me.

