Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5364B3254A6
	for <linux-unionfs@vger.kernel.org>; Fri, 30 Jan 2026 19:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769800873; cv=none; b=CUGvZG5M15nGNQKQT/zymYSGva0PvRPsE0R3nziUD+gWrpR8s43B0nnX/CfHGDm9n0KRV3JFK1SEeczlCwE3t6NmephJSzvEA7K4f59+EdIvAlJT8EjCHfsPJAhGmnOl3p1bGrhW2oxyWwMUXlDCgddHWiej/zhVWltVbF0jyVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769800873; c=relaxed/simple;
	bh=vTanwuHrjHmIYcfDTVf0pVQhAuiC/AT8S6pdAvUUccw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XKEJTb+bhHjUN5q982DTZH+sM+oSfAgf2MWvBKQp0WOv0vzihYmyybqvCcu4NWbgm/EgAbagXtiDFPcdDo070f+dwCBtcBqdN1Hc6oOB3uuRgra2geYc3hbXCMZxiIbsv8OWec6xyj3xHe6PEDLXifZIJ3K4IQ1lEdMho9oYyaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9F4/GT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9F4/GT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA9AC16AAE
	for <linux-unionfs@vger.kernel.org>; Fri, 30 Jan 2026 19:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769800873;
	bh=vTanwuHrjHmIYcfDTVf0pVQhAuiC/AT8S6pdAvUUccw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=L9F4/GT/YtT9cS/MgcCV23K1FYZ5pYZO/m/PZc8H405Zdj2+xrdXYIwrFvnGybgHO
	 yn8CHmzbhTv0IBZUMshoS3TZ11M0jLKQPJI8/WesiAOrNG3jHbaNZJSpIrnr7y2YHd
	 FVQVqtJGsqJLgRRtHvTVfH3UIJIOrL2rXkEtlXkZL4hW5uAyWqxUMaxrVZnNXYAoHU
	 vp5vIEvlD14A5dTRC9tDNoRkpYMxObBAsUXwE5thQD9XFzNTeW06BfhqNCteP4ZySn
	 o3poyEhAG2DpB9q6PX61iYhEt1hROKav8RUQ7UXOaoHMN1XCblLAwZ+gFYz5lNp2ms
	 dgEv2O40z9z9Q==
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-124a95e592fso4017358c88.0
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Jan 2026 11:21:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWr0wvqZLRIVX8u4aIRDCCTtD3JB+RjuMdGHiraKHYLwz7VjP4BwkEDH47FnmM7f84P+qWMOUDJPXi+ueTT@vger.kernel.org
X-Gm-Message-State: AOJu0YxnL+WqCjH/rKNGcw9J3TZSn1sO1T3YBFOmJ5vOe/QEzpKtYFL2
	0QfiA774ORcC9U88oLhQJ7XF9GeLbK+u83RxmaiZAJ6IPe120P097UHcTeYS0LmTeTjJPqebnYW
	Eh6kYazehM+6bxbf/2GXJwAl79X2rs/8=
X-Received: by 2002:a05:7022:418b:b0:11f:3d55:ab9a with SMTP id
 a92af1059eb24-125c0fa6663mr2360692c88.13.1769800872461; Fri, 30 Jan 2026
 11:21:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130001418.18414-1-wufan@kernel.org> <CAOQ4uxhf6EQKcoN055xzmi-RW2GPxRzz_ExsQawGQBSmoX2WYg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhf6EQKcoN055xzmi-RW2GPxRzz_ExsQawGQBSmoX2WYg@mail.gmail.com>
From: Fan Wu <wufan@kernel.org>
Date: Fri, 30 Jan 2026 11:21:00 -0800
X-Gmail-Original-Message-ID: <CAKtyLkG1_evj7=yrB6nH-8fJuP3DsWyxwrhv7O_Mk=Fy8FOvVw@mail.gmail.com>
X-Gm-Features: AZwV_QgxnseVVRad_xrDnNr9TdRQjtw8f4E6YsN-rr-SbuZB3KUXGZ8Ksfk-GWo
Message-ID: <CAKtyLkG1_evj7=yrB6nH-8fJuP3DsWyxwrhv7O_Mk=Fy8FOvVw@mail.gmail.com>
Subject: Re: [PATCH] ipe: document AT_EXECVE_CHECK TOCTOU issue on OverlayFS
To: Amir Goldstein <amir73il@gmail.com>
Cc: wufan@kernel.org, linux-security-module@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
	mic@digikod.net, miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 30, 2026 at 3:06=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Fri, Jan 30, 2026 at 1:14=E2=80=AFAM <wufan@kernel.org> wrote:
> >
> > From: Fan Wu <wufan@kernel.org>
> >
> > Document a known TOCTOU (time-of-check to time-of-use) issue when using
> > AT_EXECVE_CHECK with read() on OverlayFS.
>
> Hi Fan Wu,
>
> TBH, I don't like the way that this problem is being framed.
> IIUC, the problem is using IPE on a non-read-only fs.
> Is that correct?
>
> That fact that IPE metadata is usually coupled with read-only fs
> is interesting for the understanding of the use case, but unless
> IPE feature mandates read-only fs, this is a generic problem.
>
> OverlayFS is just one private case, which happens to be common
> in Android or containers? IDK, you did not mention this.
>
> Please describe the problem as a generic problem and give
> overlayfs as an example, preferable with references to the
> real world use cases.
>
> If I misunderstood, please explain why this problem is exclusive
> to overlayfs.
>
> Thanks,
> Amir.
>

Hi Amir,

Thanks for the review. That's exactly why we CC'd you and the
overlayfs folks, we wanted to get your perspective before documenting
this.

Let me give some background. IPE enforces execution policy based on
file integrity properties, primarily dm-verity and fs-verity. These
are the trust anchors, and files without these protections won't be
trusted by IPE. Since dm-verity and fs-verity are inherently
read-only, in typical deployments the TOCTOU issue doesn't exist. To
support overlayfs, IPE uses d_real_inode() to look through the overlay
and get the real inode from the lower layer.

Recently a new feature AT_EXECVE_CHECK was introduced to allow script
interpreters to request LSM checks on script files before execution.
The idea is: interpreter opens the script, calls execveat() with
AT_EXECVE_CHECK to verify the file passes security policy, then reads
and executes the content.

What we found is that on overlayfs with a dm-verity lower layer and
writable upper layer, when a script file only exists in the lower
layer, AT_EXECVE_CHECK passes because IPE sees it's dm-verity
protected. But if another process writes to the same path after
execveat() returns, copy-up happens and subsequent read() from the
original fd returns content from the upper layer. We verified this
through testing.

Overlayfs is popular in container environments, so we want to document
this for IPE users.

We noticed the overlayfs documentation
(https://docs.kernel.org/filesystems/overlayfs.html#non-standard-behavior)
states that if a lower layer file is opened and memory mapped,
subsequent changes are not reflected in the memory mapping. We also
verified this: mmap keeps the original lower layer content after
copy-up. One reason we CC'd you is to ask: is relying on mmap to keep
the original lower file reference a reasonable choice? Or would you
recommend against depending on this behavior?

The narrative in the patch can definitely be adjusted. Would something
like this work better:

"When using AT_EXECVE_CHECK on overlayfs, if the lower layer is
integrity-protected but the upper layer is writable, a copy-up between
the check and read() may cause the interpreter to read unverified
content."

Let us know what you think.

-Fan
