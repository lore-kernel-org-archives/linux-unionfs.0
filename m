Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A88448D1E
	for <linux-unionfs@vger.kernel.org>; Fri, 28 Aug 2026 12:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787919819; cv=pass; b=Cv2Xce7RWn1QDovQAj0S2ho6UEO8Edu2Cz8EgQ34CcqvtzzWjdx5bd4mr3tLa3Z0JvT50K5cia8UurQpoNsQzzevfxZVNG8ywjeHfurvbJ5ewWZU76Aj8opAIqozfqQawgm+SCZ8sLjLzm/+FoKWoFJDthlQnc7dvrzDLS4G1Os=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787919819; c=relaxed/simple;
	bh=jbnCdqbye1/+ycr398CqTnWMoDekXdOMK8Sg2cdpShU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o5ll5UL1zdQe8l0ywt7BcJBf4Mxmr0xZ0Awh9803BA2AInpeMSfEZaSZ83w9GV/zvYIHHwTki1tLvnVT7E6zAW5yhGdRcGGUgxDKf7wOmXXOFIRj4CDFyapqS2fgEBdbBgxscK2zy6R34uZIDnMXrU9LPFBZrS6HkeLfVDfFz7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i3nOvNpX; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i3nOvNpX"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c1600d040e4so145495266b.1
        for <linux-unionfs@vger.kernel.org>; Fri, 28 Aug 2026 05:23:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787919803; cv=none;
        d=google.com; s=arc-20260327;
        b=qCwRnP/F2SqfPUEZXjHb3GqBHza9vm/0Y8czDzq1JdHDQtZz4jqgYB09oQklB2e4LQ
         5shj1Di16Jaq2LmLAhDy+Df9e5lNL7lVqSoKFn7O3boKWAvkjLRZbt0xPPFQ8xhFGlf3
         RUG9lip/uawzHlknDAMKlUI4c5AiQknoUo4NdrJ5PlmEtEzgAU23fWaF3rmU5XbzLNKT
         FEdekJZE/pU32RlXakT5y5JbjIZutHcZxlJrCW+eWsO9eIB01ngVZyeey+jRxOebsaO1
         Xz16xmP5MfUaXOj/LY7UF0M7Wy95Y8/cUwYcg4jXU+wXswy4vduUPdvOgtq1RIIlnKce
         dZeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PLuOPVgzMrabh8iP2CrClpX8J/e3bzGLeeBKYH4Ndlo=;
        fh=hdpLxclObwM8a38UV9sD742v05vO+Usb8XhREX0pThA=;
        b=XFkZT4PqI7gw3jCuE69AQIeqSMAc55vdl2C/yHOlJGNalvw2Cv8OfCuHTaTHTUvbH5
         zfBQpsw7fWXKpQ/NSL3i93f/AxkSXvaqtBeir6C5FPoa/5OFZZvI6P9m2e5MkaUEfTaa
         Uu41PSkI6LFKb38NDvADVPvxkBsEkSciucN2ENcZ4Ba1ruFG4sVwZGihSa8Gb17pJ8G9
         wBkd/Wz37QNSzUGHpfmrXZaw+22XjCg/V5JlCTjLYSGG65a/VxNIrN6/4sX1L0E3hT+i
         mgFOT/RPYKZ1YYWMYERISWBIOcZIAXHjnU5BOaNUcdUclQ5r/8S0VcA+fLTTG8QvR0t4
         53nQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787919803; x=1788524603; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PLuOPVgzMrabh8iP2CrClpX8J/e3bzGLeeBKYH4Ndlo=;
        b=i3nOvNpXTDGvAAOwDRKcyOYW8Tn8hLWQt3LFjBmH2mX3MeFr1HGuLRaq21EZPvRF8g
         xtM3fK7wwFT4ao3PW/5BQ9r3YiQaQaT86Q+FG8RDmJFkzstl3IyimkR19cgiWsEYA7IV
         3JVtLJdy0hR/x72cc3uWw1OB87UxpyzBr0ivodgvflF9OllZ8CRb3UAFdKgML8QYIZmS
         MMBxUFtON8gFJDx3mTNQjbDV41NnRrgJHscWZKhwF0YGjsAm66vBv1mLrn6/lgfxSpp3
         tRtfEZKk5O/CbqjGpe04bMVUikR0f/ffIj1VQx0op9C8x13VSlMyDETtWu2y70ZF/pCo
         CWdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787919803; x=1788524603;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PLuOPVgzMrabh8iP2CrClpX8J/e3bzGLeeBKYH4Ndlo=;
        b=AnER4U7DfNFwjfq+oe2FGq6F74sTkUrmrq2sGbVQPjJEChPalBMhUtmG2kNYM04e/9
         Gh1ulJ/Orx+fr4XGKprd7gl5wv2trTUFRPrK1pNajMge7Lfo52/OqO1cBnF14MtK7xTq
         3ALRV2dNSOxD+bG+VHO+CDDf/fKPK8KLD/Nvb6RbMhVv6rOe3TnKTZQDzF1bs0evzhDW
         Xsse6nUPs76+dHfG2khVySlhGtCkOYx0+8F6Yrhc9jVg7KcOXeVGig7LfuJaOD66P4Qo
         6/oPeQa4e7v1/+xfv3zKvaNEjZr7liy9u0IhYquqHTFjD8RjISkNIO2KdyiZVSVeqtBp
         02Kg==
X-Forwarded-Encrypted: i=1; AHgh+RrnzUT2/fPfdMm40TKMUugngV/MY6t4Bs1oNTp4qqtNbiWlKKkgg8xe9yMQAeV3lYXNFiU4e5SE3+YR6p6F@vger.kernel.org
X-Gm-Message-State: AFuF++lhKYPEowQ4fHHnqpQJGpwmRKGfNECJA1acvkHaxs63/r6ZWpB/
	U+Z1rpCE1kvyeHXJffdiq2aXKjVoasLrbZMFUAUnu/rMzQFh0U13/oYMHE9hlv61Yh589NLQoCn
	0c0j7xODny+9JKOXd+MWSZowlNX0qN6Q=
X-Gm-Gg: AR+sD12UyY3jBtOsEjnLzUA1CZv1MaMOTpxBY9DH2PG31kP0mIw7rJzrKOg5FC2ymg3
	T+DjDmiXQvf9IHqJRxh98SnwPyA5XllQIcC9rcn6yWhqRKqxVKYlhrXn8Po3TVyGy2Am3njTV8Q
	BxNhB6oIm56QWuREryFqPSMr0paT26XK76DKFVLyb0Viv//diTqEzb3/TMC3pMBLd+jiOqKX/Mx
	OMOawx/Ql4XEW9jDXC6kq/OGrOkRwyrBV3jW//MFYZjjIk67LOPuYRAF7tOHMs+38LcR2Fujhcu
	vZhE1TKnL46TmFLGtmuBlIw0VbiJrS1WruzL4WsTUc9T02AEePsxDqV3
X-Received: by 2002:a17:907:1b0e:b0:c1c:2218:f317 with SMTP id
 a640c23a62f3a-c2535eab9b1mr1082654866b.2.1787919803004; Fri, 28 Aug 2026
 05:23:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827170718.497-1-aa9736195201@gmail.com>
In-Reply-To: <20260827170718.497-1-aa9736195201@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 28 Aug 2026 14:23:11 +0200
X-Gm-Features: AcwNN1Xe-iVgNN_CSVbFy3js4YMDBqwZBjkmZg_1221I6kuu3xfgQZkLpUKwgHI
Message-ID: <CAOQ4uxjxDV0U9yrDA_StN968P_6cpjRAN2mBCx1c_RYd7BF4Og@mail.gmail.com>
Subject: Re: [PATCH] ovl: implement ->get_unmapped_area()
To: Yuan-Hao Hsu <aa9736195201@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, Linux MM <linux-mm@kvack.org>, 
	Matthew Wilcox <willy@infradead.org>, Christian Brauner <brauner@kernel.org>, 
	"zhangyi (F)" <yi.zhang@huawei.com>, tujinjiang@huawe.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 7:07=E2=80=AFPM Yuan-Hao Hsu <aa9736195201@gmail.co=
m> wrote:
>
> ovl_mmap() passes realfile to the underlying filesystem, so the VMA it
> returns is backed by realfile, not by the overlayfs file.
>
> Address selection is not delegated.  __get_unmapped_area() looks at the
> overlayfs file's f_op, ovl_file_operations does not implement
> ->get_unmapped_area(), and the mapping lands wherever
> mm_get_unmapped_area() puts it.  ext4, xfs and btrfs all point
> ->get_unmapped_area() at thp_get_unmapped_area(); none of that is reached=
.
>
> vaddr - file_offset is then not a multiple of PMD_SIZE,
> thp_vma_suitable_order() rejects the VMA, and the PMD-sized folios the
> underlying filesystem already has in the page cache are never mapped by
> a PMD.
>
> Delegate to the file ovl_mmap() will use.  Calling thp_get_unmapped_area(=
)
> here instead would force alignment on filesystems that deliberately do
> not implement ->get_unmapped_area(), which commit 34d7cf637c43 ("mm:
> don't try THP alignment for FS without get_unmapped_area") avoided.
> fs/proc delegates the same way in pde_get_unmapped_area().
>
> Reading a 1025M ext4 file through mmap(NULL, ...), 97% of its page cache
> in PMD-sized folios, 15 runs:
>
>                      PMD congruent  minor faults  page tables
>   ext4, directly             15/15           764          68K
>   overlayfs, before            0/5         16186        2056K
>   overlayfs, after           15/15           764          68K
>
> Fault counts had 0 stddev.  Median read time 17.4ms -> 4.80ms, against
> 4.92ms for the same file on ext4.
>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
>
> ---
>  fs/overlayfs/file.c |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index f3d97eb146e8..0d985025f4c8 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -13,6 +13,7 @@
>  #include <linux/security.h>
>  #include <linux/fs.h>
>  #include <linux/backing-file.h>
> +#include <linux/sched/mm.h>
>  #include "overlayfs.h"
>
>  static char ovl_whatisit(struct inode *inode, struct inode *realinode)
> @@ -465,6 +466,30 @@ static int ovl_fsync(struct file *file, loff_t start=
, loff_t end, int datasync)
>                 return vfs_fsync_range(upperfile, start, end, datasync);
>  }
>
> +static unsigned long ovl_get_unmapped_area(struct file *file,
> +                                          unsigned long addr, unsigned l=
ong len,
> +                                          unsigned long pgoff, unsigned =
long flags)
> +{
> +       struct ovl_file *of =3D file->private_data;
> +       struct file *realfile =3D of->realfile;
> +
> +       /*
> +        * ovl_mmap() hands realfile to the underlying filesystem, so the=
 vma
> +        * ends up backed by realfile.  Let that filesystem pick the addr=
ess
> +        * too, or one that needs a specific alignment - to allow PMD map=
pings,
> +        * for example - never gets asked for one.
> +        */
> +       if (realfile->f_op->get_unmapped_area)
> +               return realfile->f_op->get_unmapped_area(realfile, addr, =
len,
> +                                                        pgoff, flags);
> +
> +#ifdef CONFIG_MMU
> +       return mm_get_unmapped_area(file, addr, len, pgoff, flags);
> +#endif

That looks quite ugly.
Can't we have a noop inline helper for mm_get_unmapped_area()
fo nommu?

> +
> +       return addr;
> +}
> +
>  static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>         struct ovl_file *of =3D file->private_data;
> @@ -654,6 +679,7 @@ const struct file_operations ovl_file_operations =3D =
{
>         .write_iter     =3D ovl_write_iter,
>         .fsync          =3D ovl_fsync,
>         .mmap           =3D ovl_mmap,
> +       .get_unmapped_area =3D ovl_get_unmapped_area,
>         .fallocate      =3D ovl_fallocate,
>         .fadvise        =3D ovl_fadvise,
>         .flush          =3D ovl_flush,
>
> base-commit: 26260251022fbc2f248a3d747a9b2b961b18d2d8

Since mmap is going through backing_file_mmap() probably a good idea to
pass this method through a backing_file helper as well.

But more importantly, adding MM people to this patch review, mainly the one=
s
that participated in the discussion over patch to fix similar issues
in 2024 [1].
Most of the concerns in that patch seem to have been addressed (?)

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20241205143038.3260233-1-tujinjia=
ng@huawei.com/
