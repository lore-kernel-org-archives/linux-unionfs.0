Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33029204097
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Dec 2024 12:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733489910; cv=none; b=PZ0PLIvCFCmgyg0buwQa8LV9M0bJvSfiHS9HF8PKQvq7G7QGzfcUIxtu3Maz8RFenP2CnlTOWKEi+16cC/Nif23MixnIA5KG2qAbZEbJsu5ZSQefcmrn+5HV0HqdcZnRQjXQiCSeAseal7EhsT/yCf/OGwfLCQoccaSwmRUsasg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733489910; c=relaxed/simple;
	bh=Q1RGgooW2J4A1jGfCDqKA4rc4IhXHbYXRYrfewrVd50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u/2pIbFFy8E+cJa48oKztUcWLAOI3wHnSgyPup72fxpDW5NNdelOH0CMXUqQjjYhEDij56qeZv/hwKglhaTjIo/cE3rPlooQ8gq+0HXKrt68pNyE9IfLf3o7wBqzvyyZCPq58gFITSllR3v+hN7TB4sqMtdG3vPB0Ev8Sd3AH78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FzQcpX+d; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FzQcpX+d"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5cecbddb574so2351779a12.1
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Dec 2024 04:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733489904; x=1734094704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8F7HvsLxqO/BsNvoLEm5ZBXsSUQ9vSZoPpPNvMFdc9I=;
        b=FzQcpX+dSNv7yX59fVgaMKdzov454/Gr8GiK9uA8aVbko7a3jCRACvNHcri4gpSMqW
         8S/BU0jq7u9hYUi3+kQ/gbxVXA9BIuUoAmddxbq41m8qbtl3dhaKRiFWHzMw2+wsZD8k
         2/UE0PZIHJ2X4JyN4LsDOSVU4CaDphFrFRXWgScqsPBrWoWj7L6gFIa+wGWm0tCo7L0J
         oXvbgeRbmKsz4bQ3TsO4AZbbQD6fhMkb+3MeDIyRRskjYcWrFkXPKlEFtCCQn9G0tqQt
         Ybkj1ndMaunIXPlzSqWLr1ZbSszxxQJh//8BjU+VIUPaIZ0DZArbP0Y9CjWNSTqwRtXU
         yzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733489904; x=1734094704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8F7HvsLxqO/BsNvoLEm5ZBXsSUQ9vSZoPpPNvMFdc9I=;
        b=tQaFXFdUIPZ77AY2FgEJrzfhEOKanAxzEE/IBLRwypR4uzXKPwmgNNLyo8n5cuCOu/
         xnkKZZE5VejPtvO0pyofM4WGCAgbjxnFDlhhI8MGQTVMQZ3jYeqlrNgxaKxhFf6AvPeZ
         OCWE+qg6uOXohC0OFamvLQChtZxXfo36JPKo/vqclfK2AZ48+EmXxcwPUx697PnHtERs
         zo11cO4wrRPZ6tn9TGADHbBriegfnPsvcnUMJIDXPq2ZqKPORMS9r3J3uWYfFvwEnLk2
         SgR3r1cllaunuWM4oCihor7uwotYOus/1MIxtbBQNxSQi0ekjGqo+EfQuUNjgTHQ/tPT
         iaHg==
X-Forwarded-Encrypted: i=1; AJvYcCWIjpBEE2lIVKBlJjZOz8wjmIl7JJgAlXzTOuT3tEl2robKUl5Izn2IDFdKMnz60f4bwpM7ZYxCgn5IGl7o@vger.kernel.org
X-Gm-Message-State: AOJu0YxM0XiN6ZPdDMMlBKafbiqeFUJNxklFIZLWzgRjtHPzDLIlB1tj
	36dgnq0t9w7A+skH0KkDgxYRrZVlwvo7a6voaK+EP6I83QwOg3IlLZ9Fw4CB7WK0zpjjjmEu5qm
	XIUgeH/8N8AmfjhEpVLwzzfNFStA=
X-Gm-Gg: ASbGnctXM+Q5RTVLAm9GUsEsAt35rgIRNX4NFjmTGxUthgEgO1njqqaEDXA29w+/Z+4
	QksQaWAm5AgdHq3JIaTHbLeTRZwZwJeA=
X-Google-Smtp-Source: AGHT+IF3tHBfl5kltrr2azKq6xvF6nb17womuIoRJUQHPcjAm6Az54Ihchm8UFkzk5wc5B0MCmF7nXHn5vohnmEgXY0=
X-Received: by 2002:a17:906:32d0:b0:aa6:1c4b:9c5b with SMTP id
 a640c23a62f3a-aa639fa5cfamr165384766b.7.1733489903865; Fri, 06 Dec 2024
 04:58:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local> <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
 <a39ef271-dc1b-4f61-ba01-dde5b127bef2@lucifer.local> <f2668332-78ac-4dc1-abcc-440e38964ccc@huawei.com>
In-Reply-To: <f2668332-78ac-4dc1-abcc-440e38964ccc@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 6 Dec 2024 13:58:12 +0100
Message-ID: <CAOQ4uxh5azF6As6TvV2eCKpnbct0-vNwJLTAwSiKc6QjK5TUBw@mail.gmail.com>
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's get_unmapped_area()
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jinjiang Tu <tujinjiang@huawei.com>, miklos@szeredi.hu, 
	akpm@linux-foundation.org, vbabka@suse.cz, jannh@google.com, 
	linux-mm@kvack.org, linux-unionfs@vger.kernel.org, sunnanyong@huawei.com, 
	yi.zhang@huawei.com, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 6, 2024 at 11:45=E2=80=AFAM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
>
>
> On 2024/12/6 17:25, Lorenzo Stoakes wrote:
> > To be clear - I'm not accepting the export of __get_unmapped_area() so =
if
> > you depend on this for this approach, you can't take this approach.
> >
> > It's an internal implementation detail. That you choose to make your
> > filesystem possibly a module doesn't mean that mm is required to export
> > internal impl details to you. Sorry.
> >
> > To rescind this would require a very strong argument, you have not prov=
ided
> > it.
> >
> > On Fri, Dec 06, 2024 at 11:35:08AM +0800, Jinjiang Tu wrote:
> >>
> >> =E5=9C=A8 2024/12/5 23:04, Lorenzo Stoakes =E5=86=99=E9=81=93:
> >>> + Matthew for large folio aspect
> >>>
> >>> On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
> >>>> During our tests in containers, there is a read-only file (i.e., sha=
red
> >>>> libraies) in the overlayfs filesystem, and the underlying filesystem=
 is
> >>>> ext4, which supports large folio. We mmap the file with PROT_READ pr=
ot,
> >>>> and then call madvise(MADV_COLLAPSE) for it. However, the madvise ca=
ll
> >>>> fails and returns EINVAL.
> >>>>
> >>>> The reason is that the mapping address isn't aligned to PMD size. Si=
nce
> >>>> overlayfs doesn't support large folio, __get_unmapped_area() doesn't=
 call
> >>>> thp_get_unmapped_area() to get a THP aligned address.
> >>>>
> >>>> To fix it, call get_unmapped_area() with the realfile.
> >>> Isn't the correct solution to get overlayfs to support large folios?
> >>>
> >>>> Besides, since overlayfs may be built with CONFIG_OVERLAY_FS=3Dm, we=
 should
> >>>> export get_unmapped_area().
> >>> Yeah, not in favour of this at all. This is an internal implementatio=
n
> >>> detail. It seems like you're trying to hack your way into avoiding
> >>> providing support for large folios and to hand it off to the underlyi=
ng
> >>> file system.
> >>>
> >>> Again, why don't you just support large folios in overlayfs?
> >>>
> >>> Literally no other file system or driver appears to make use of this
> >>> directly in this manner.
> >>>
> >>> And there's absolutely no way this should be exported non-GPL as if i=
t were
> >>> unavoidable core functionality that everyone needs. Only you seem to.=
..
> >>>
> >>>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> >>>> ---
> >>>>    fs/overlayfs/file.c | 20 ++++++++++++++++++++
> >>>>    mm/mmap.c           |  1 +
> >>>>    2 files changed, 21 insertions(+)
> >>>>
> >>>> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> >>>> index 969b458100fe..d0dcf675ebe8 100644
> >>>> --- a/fs/overlayfs/file.c
> >>>> +++ b/fs/overlayfs/file.c
> >>>> @@ -653,6 +653,25 @@ static int ovl_flush(struct file *file, fl_owne=
r_t id)
> >>>>            return err;
> >>>>    }
> >>>>
> >>>> +static unsigned long ovl_get_unmapped_area(struct file *file,
> >>>> +          unsigned long addr, unsigned long len, unsigned long pgof=
f,
> >>>> +          unsigned long flags)
> >>>> +{
> >>>> +  struct file *realfile;
> >>>> +  const struct cred *old_cred;
> >>>> +  unsigned long ret;
> >>>> +
> >>>> +  realfile =3D ovl_real_file(file);
> >>>> +  if (IS_ERR(realfile))
> >>>> +          return PTR_ERR(realfile);
> >>>> +
> >>>> +  old_cred =3D ovl_override_creds(file_inode(file)->i_sb);
> >>>> +  ret =3D get_unmapped_area(realfile, addr, len, pgoff, flags);
> >>>> +  ovl_revert_creds(old_cred);
> >>> Why are you overriding credentials, then reinstating them here? That
> >>> seems... iffy? I knew nothing about overlayfs so this may just be a
> >>> misunderstanding...
> >>
> >> I refer to other file operations in overlayfs (i.e., ovl_fallocate, ba=
cking_file_mmap).
> >> Since get_unmapped_area() has security related operations (e.g., secur=
ity_mmap_addr()),
> >> We should call it with the cred of the underlying file.
> >>
> >>>
> >>>> +
> >>>> +  return ret;
> >>>> +}
> >>>> +
> >>>>    const struct file_operations ovl_file_operations =3D {
> >>>>            .open           =3D ovl_open,
> >>>>            .release        =3D ovl_release,
> >>>> @@ -661,6 +680,7 @@ const struct file_operations ovl_file_operations=
 =3D {
> >>>>            .write_iter     =3D ovl_write_iter,
> >>>>            .fsync          =3D ovl_fsync,
> >>>>            .mmap           =3D ovl_mmap,
> >>>> +  .get_unmapped_area =3D ovl_get_unmapped_area,
> >>>>            .fallocate      =3D ovl_fallocate,
> >>>>            .fadvise        =3D ovl_fadvise,
> >>>>            .flush          =3D ovl_flush,
> >>>> diff --git a/mm/mmap.c b/mm/mmap.c
> >>>> index 16f8e8be01f8..60eb1ff7c9a8 100644
> >>>> --- a/mm/mmap.c
> >>>> +++ b/mm/mmap.c
> >>>> @@ -913,6 +913,7 @@ __get_unmapped_area(struct file *file, unsigned =
long addr, unsigned long len,
> >>>>            error =3D security_mmap_addr(addr);
> >>>>            return error ? error : addr;
> >>>>    }
> >>>> +EXPORT_SYMBOL(__get_unmapped_area);
> >>> We'll need a VERY good reason to export this internal implementation
> >>> detail, and if that were provided we'd need a VERY good reason for it=
 not
> >>> to be GPL.
> >>>
> >>> This just seems to be a cheap way of invoking (),
> >>> maybe, if it is being used by the underlying file system.
> >>
> >> But the underlying file system may not support large folio. In this ca=
se,
> >> the mmap address doesn't need to be aligned with THP size.
> >
> > But it'd not cause any problems to just do that anyway right? I don't t=
hink
> > many people think 'oh no I have a PMD aligned mapping now what will I d=
o'?
> >
> > Again - the right solution here is to handle large folios in overlayfs =
as
> > far as I can tell.
>
> I think this is not to handle large folio for overlayfs, it is about vma
> alignment or vma allocation for memory mapped files,
>
>
> 1) many fs support THP mapping, using thp_get_unmapped_area(),
>
> fs/bcachefs/fs.c:       .get_unmapped_area =3D thp_get_unmapped_area,
> fs/btrfs/file.c:        .get_unmapped_area =3D thp_get_unmapped_area,
> fs/erofs/data.c:        .get_unmapped_area =3D thp_get_unmapped_area,
> fs/ext2/file.c: .get_unmapped_area =3D thp_get_unmapped_area,
> fs/ext4/file.c: .get_unmapped_area =3D thp_get_unmapped_area,
> fs/fuse/file.c: .get_unmapped_area =3D thp_get_unmapped_area,
> fs/xfs/xfs_file.c:      .get_unmapped_area =3D thp_get_unmapped_area,
>
> 2) and some fs has own get_unmapped_area callback too,
>
> fs/cramfs/inode.c:      .get_unmapped_area      =3D cramfs_physmem_get_un=
mapped_area,
> fs/hugetlbfs/inode.c:   .get_unmapped_area      =3D hugetlb_get_unmapped_=
area,
> fs/ramfs/file-mmu.c:    .get_unmapped_area      =3D ramfs_mmu_get_unmappe=
d_area,
> fs/ramfs/file-nommu.c:  .get_unmapped_area      =3D ramfs_nommu_get_unmap=
ped_area,
> fs/romfs/mmap-nommu.c:  .get_unmapped_area      =3D romfs_get_unmapped_ar=
ea,
> mm/shmem.c:     .get_unmapped_area =3D shmem_get_unmapped_area,
>
> They has own rules to get a vma area, but with overlayfs(tries to
> present a filesystem which is the result over overlaying one filesystem
> on top of the other), we now only use the default
> mm_get_unmapped_area_vmflags() to get a vma area, since the overlayfs
> has no '.get_unmapped_area' callback.
>
> do_mmap
>    __get_unmapped_area
>      // get_area =3D NULL
>      mm_get_unmapped_area_vmflags
>    mmap_region
>      mmap_file
>        ovl_mmap
>
> It looks wrong, so we need to get the readfile via ovl_real_file()
> and use realfile' get_unmapped_area callback, and if the realfile
> is not with the callback, fallback to the default
> mm_get_unmapped_area(),
>
> >
> > In any case as per the above, we're just not exporting
> > __get_unmapped_area(), sorry.
> >
>
> So maybe use mm_get_unmapped_area() instead of __get_unmapped_area(),
> something like below,
>
> +static unsigned long ovl_get_unmapped_area(struct file *file,
> +               unsigned long addr, unsigned long len, unsigned long pgof=
f,
> +               unsigned long flags)
> +{
> +       struct file *realfile;
> +       const struct cred *old_cred;
> +
> +       realfile =3D ovl_real_file(file);
> +       if (IS_ERR(realfile))
> +               return PTR_ERR(realfile);
> +
> +       if (realfile->f_op->get_unmapped_area) {
> +               unsigned long ret;
> +
> +               old_cred =3D ovl_override_creds(file_inode(file)->i_sb);
> +               ret =3D realfile->f_op->get_unmapped_area(realfile, addr,=
 len,
> +                                                       pgoff, flags);
> +               ovl_revert_creds(old_cred);
> +
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return mm_get_unmapped_area(current->mm, file, addr, len, pgoff,
> flags);
> +}
>
> Correct me If I'm wrong.
>

You just need to be aware of the fact that between ovl_get_unmapped_area()
and ovl_mmap(), ovl_real_file(file) could change from the lower file, to th=
e
upper file due to another operation that initiated copy-up.

Thanks,
Amir.
