Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C6B3E44E0;
	Tue, 30 Jun 2026 07:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782806158; cv=none; b=sCDAaspxaJ0gNBydahVGhS3igJcXKz51/4uqRZZ/zQyJxPllEn1n2ryzIsXOq1H7aK9+03ApMYyFoGa4ebQM27IYApunOr8t+pFrJGYLy4IncMyIWHeBqXyT9b4FGMsLV5kbgoeA4jpikjXXO4QZmT6Bk9T6ro/1lFz5tAcvYjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782806158; c=relaxed/simple;
	bh=akQT6JRfJ1Zkbm0d13uEQPaH8NlEtNJnfMROgJGxvXM=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=IkzUDIYcWHYwkZBosvgZIc/ELGsLsdOprMhE9JULV1gMLb0xDrMWJyvjb4JU8gpgtSK++er2Om10FRa2kndE7Od4/3uCFzj+7fH7QP2vXpOiOkE+1rzeVWsuw0BkLVhOU5Av0P2LsGfhDrBGmN1abbQ9fjTbTNuj2PEQFyD/fqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4CwXk6Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4CwXk6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52031F000E9;
	Tue, 30 Jun 2026 07:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782806156;
	bh=w2dS4VqRw/Em0OvDV2StfeJ9DlNgRzJR6JUzBHHof/0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=V4CwXk6YKnkYyH5J826DwWWvxDBFMYJsBkeZ0jSkUuMCi7MRUOwPXrQIs0ZHNDKTe
	 2ephx8Dr1Na5hqDsI++k6XEZ7iCni7ECvJYyTPYqj3g2lXsipul+IGD/QTusb1vOTm
	 OAqqQxxkgt0xfx9VoWOeskdhoVrsyyJ450FyZnKwxmnnIWvfbkDizSNP3kFvy9Ob+W
	 sLw0QaG9BhNasKCuFOOhQclfgqewrbO1QbkwMCqFsPukzl/hosk5V6ICSYZFcwKbFH
	 5z5sjJV2t/O1coQ0RxG+9M7fpfWNHyh8S9q8n8Sv8Yc5JFX2ToBAYBkY3yLAQsYxUr
	 kntxXfArnl0VA==
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
 Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
In-Reply-To: <CAOQ4uxiNrEZ8rsRc11mdjkMWe3dfThE0DJ2vXuO0yiNemnpR6A@mail.gmail.com>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
 <ajqOyIA8tPQsxfz6@cmpxchg.org>
 <3f6392aa-c1f6-4263-8892-978dacbbd8ca@virtuozzo.com>
 <CAOQ4uxhras5YAr8_HBpuHSDwvfiEF8vAr0NDB0R_PXtGDhnqjQ@mail.gmail.com>
 <20260625-lehrbuch-gehalt-wichen-1b2f3533efbe@brauner>
 <CAOQ4uxiNrEZ8rsRc11mdjkMWe3dfThE0DJ2vXuO0yiNemnpR6A@mail.gmail.com>
Date: Tue, 30 Jun 2026 09:55:50 +0200
Message-Id: <20260630-tierisch-ehrbaren-errichten-bed402a0a26c@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3948; i=brauner@kernel.org;
 h=from:subject:message-id; bh=akQT6JRfJ1Zkbm0d13uEQPaH8NlEtNJnfMROgJGxvXM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ5l3WEHDrovNv1wMy7DPHbGI4bei2/3jc3L9d3/brdP
 qJvp1nYd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk34GR4Ybbp8jPbOuYjn14
 0nyR4VK4ZUDq6amfGTtvldl4p3+yKWH4763BU/ipx7TfP8TdQ8Wx8fuNS5bxvaenzZovVnl2+oo
 gFgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-06-26 17:18 +0200, Amir Goldstein wrote:
> On Thu, Jun 25, 2026 at 12:36 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On 2026-06-23 17:34:47+02:00, Amir Goldstein wrote:
> > > On Tue, Jun 23, 2026 at 4:55 PM Pavel Tikhomirov
> > > <ptikhomirov@virtuozzo.com> wrote:
> > >
> > > > On 6/23/26 15:48, Johannes Weiner wrote:
> > > >
> > > > Yes, AFAIU in overlay when we use realfile we should always use it
> > > > with_ovl_creds(), even though I don't think there is anything cred related
> > > > in filemap_cachestat(), I still think we should follow the common pattern
> > > > other overlay helpers use (similar to ovl_fadvise() and ovl_flush()).
> > > >
> > > > note: Actually some places get ovl_real_file() and use it without
> > > > with_ovl_creds(), e.g.: ovl_read_iter, ovl_write_iter, ovl_splice_read,
> > > > ovl_splice_write. But those look more of an exception than the general
> > > > rule. All other instances use with_ovl_creds().
> > >
> > > Use with_ovl_creds() is a good practice to keep the mental security model,
> > > but it is useless if the security check (can_do_cachestat) is not in the
> > > vfs helper (vfs_cachestat), so please move it there.
> > >
> > > Also it kind of makes more sense to check (flags != 0) in sys_cachestats
> > > before checking permissions.
> > >
> > > > Also there are simingly no other file_operations which return "realfile"
> > > > for further processing, mostly the operation from fsops simply replaces
> > > > general operation with its own logic completely.
> > > >
> > > > Thanks for your review!
> > > >
> > > > ps: Hope overlay maintainers will correctly if I'm getting this wrong.
> > >
> > > I don't think this is wrong per-se, except for can_do_cachestat().
> > >
> > > Just be aware that the real file could change from one cachestat
> > > call to the next (i.e. due to copy up).
> >
> > I'm really grump about adding a new file operation just for a
> > special-sauce system call which is under a CONFIG_* option even. We're
> > not going to set the precedent of piling on custom file operations for a
> > single filesystem everytime someone adds a new system call unless
> > absolutely necessary.
> 
> I had a similar reaction.
> 
> > This looks like it could just use a new helper in
> > fs/backing_file.c that the cachestat thing can call to use the correct
> > file.
> >
> 
> I was considering suggesting this as well.
> Having f_real_file() complement
> 
> but technically, can_do_cachestat() should be checked against
> the overlayfs file/inode AND also against the real file/inode with
> ovl_creds.
> 
> I'd love to be able to provide a backing_file "template" for
> operations, but I don't have a good idea how to do that.
> Do you?

diff --git a/fs/file_table.c b/fs/file_table.c
index c68b8c0a4097..d93059d53e88 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -57,6 +57,8 @@ struct backing_file {
 #ifdef CONFIG_SECURITY
        void *security;
 #endif
+       unsigned int flags;
+       struct cred *backing_cred;
 };

 diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 27cc07738f33..64e07ebc43b0 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -50,6 +50,12 @@ static struct file *ovl_open_realfile(const struct file *file,

                        realfile = backing_file_open(file,
                                                     flags, realpath, current_cred());
+
+                       // Raises ->flags |= BACKING_FILE_CREDS and sets ->creds to ->backing_cred.
+                       backing_file_set_creds(file, ovl_creds(file_inode(file)->i_sb));
+                       // Now add a helper that performs permission checks on
+                       // both creds for that cachestat() thing and returns
+                       // the actual file to operate on.
                }
        }

something like that?

