Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13424374E5B;
	Thu, 25 Jun 2026 10:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782383809; cv=none; b=KT4gcF+3tQWG9KMINNzYoRdkXrPrubHeSAh8TqACW+9Qvy6mTxAsT0YZ4887hrktQ0Nfc9pj/P94IxSeskfbB94Xl+03KYRG+ppHV0eQp8iNGmveVrBniZQb77AZrhjcKXgbEb2HMnB8UOqw5GiiCrDKNaNZFDeIJHvrIbZEtv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782383809; c=relaxed/simple;
	bh=sxA68pq5S5gKI8RjSDeZoQAs04oas8GQddQ+uQZURLY=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=rjxpdgIBtbcRaGovsVXLjV94XNzWeeqwLouAnHRKiRh8wq8nt+wBfpMZ7uDT9DDJWuUo7mNN2lXirfyjoZNibs+QzVWEoRe3hp7Z4RbownrmsZ71wObeXHM/uPM0P+HHcn8wzD8+yPSnnHNB36a/8+H0FOr7SVn5RzaIxGKJ1fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUW8gAvd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUW8gAvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F0B1F000E9;
	Thu, 25 Jun 2026 10:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782383807;
	bh=cWsRc7MdRTfjdlpUKPT9bAJCUmcDDpg9+U9SCGAGjJw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=XUW8gAvdo3iOuxiz+MGgyMFo/1gdypGVQtl8VAOyRISgTiliNCjCdQMQo55HY/AlZ
	 jocfZlcnMpkhK2DJ0KSAdf6cfoUNqanZWrSL7B95Og/fPszR9mnrpyMElfp6CfoBFI
	 Dr1UFhBvdGjiC/N9J184kjivsbdlXYklES7rp+Lv9QYqH1B3ox2Vn6kwEwhWbO/Uje
	 1IEOdgdhPZvJgdfdUyrddAE0/l4v+tutL8Z77OEfDMswxXzsFg8+lzIjc5wgS2rz6v
	 XtrVTfi+GYksmJKuAB3cHavdtb+OhSCzM+PfI2LQ4tuVBVHT5hcCHmZKhfz2dqcvhR
	 ikkbp5FTbNJnQ==
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
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
 Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
In-Reply-To: <CAOQ4uxhras5YAr8_HBpuHSDwvfiEF8vAr0NDB0R_PXtGDhnqjQ@mail.gmail.com>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
 <ajqOyIA8tPQsxfz6@cmpxchg.org>
 <3f6392aa-c1f6-4263-8892-978dacbbd8ca@virtuozzo.com>
 <CAOQ4uxhras5YAr8_HBpuHSDwvfiEF8vAr0NDB0R_PXtGDhnqjQ@mail.gmail.com>
Date: Thu, 25 Jun 2026 12:36:42 +0200
Message-Id: <20260625-lehrbuch-gehalt-wichen-1b2f3533efbe@brauner>
X-Mailer: b4 0.16-dev-d9d01
X-Developer-Signature: v=1; a=openpgp-sha256; l=2061; i=brauner@kernel.org;
 h=from:subject:message-id; bh=sxA68pq5S5gKI8RjSDeZoQAs04oas8GQddQ+uQZURLY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTZsuyON9+8ekfYzpun2WtXl25LeusVGcrEesFIrew8p
 0L9j9L9HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABP57sTwP43riwPH4/RjwnGB
 F2plTv5aH6Uy3Ujpo0vkico9lS2/kxkZ3u14sJ25VDdJ9fwDxV1Wk7uDNMW3T/3DuPXPbj73Ao0
 ARgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-06-23 17:34:47+02:00, Amir Goldstein wrote:
> On Tue, Jun 23, 2026 at 4:55 PM Pavel Tikhomirov
> <ptikhomirov@virtuozzo.com> wrote:
> 
> > On 6/23/26 15:48, Johannes Weiner wrote:
> >
> > Yes, AFAIU in overlay when we use realfile we should always use it
> > with_ovl_creds(), even though I don't think there is anything cred related
> > in filemap_cachestat(), I still think we should follow the common pattern
> > other overlay helpers use (similar to ovl_fadvise() and ovl_flush()).
> >
> > note: Actually some places get ovl_real_file() and use it without
> > with_ovl_creds(), e.g.: ovl_read_iter, ovl_write_iter, ovl_splice_read,
> > ovl_splice_write. But those look more of an exception than the general
> > rule. All other instances use with_ovl_creds().
> 
> Use with_ovl_creds() is a good practice to keep the mental security model,
> but it is useless if the security check (can_do_cachestat) is not in the
> vfs helper (vfs_cachestat), so please move it there.
> 
> Also it kind of makes more sense to check (flags != 0) in sys_cachestats
> before checking permissions.
> 
> > Also there are simingly no other file_operations which return "realfile"
> > for further processing, mostly the operation from fsops simply replaces
> > general operation with its own logic completely.
> >
> > Thanks for your review!
> >
> > ps: Hope overlay maintainers will correctly if I'm getting this wrong.
> 
> I don't think this is wrong per-se, except for can_do_cachestat().
> 
> Just be aware that the real file could change from one cachestat
> call to the next (i.e. due to copy up).

I'm really grump about adding a new file operation just for a
special-sauce system call which is under a CONFIG_* option even. We're
not going to set the precedent of piling on custom file operations for a
single filesystem everytime someone adds a new system call unless
absolutely necessary. This looks like it could just use a new helper in
fs/backing_file.c that the cachestat thing can call to use the correct
file.

