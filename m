Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0l7tqMw5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="T5CldEvp"
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79503C1
	for <linux-unionfs@vger.kernel.org>; Tue, 21 Nov 2023 01:59:49 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EBE221F8A8;
	Tue, 21 Nov 2023 09:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1700560788;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z03I7kh4CAXfzLeK++nj9HbakSFizkRFUrtUYd0SDRg=;
	b=0l7tqMw5rVEpTK7+DOpXqvJQtXpKXiFfLWHz/9iP7ERA7sliHmcqDMGC5DdIylimad7CBh
	XYsscn3QTbF8+8OmZtMSLdKDt6V0uLB9Nz3lVLe3aKSQCUan7/QXhN87+T3wQLKzSoWN4g
	Jja6GgseMtogaBMQ71PsUFpNajMav40=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1700560788;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z03I7kh4CAXfzLeK++nj9HbakSFizkRFUrtUYd0SDRg=;
	b=T5CldEvpHtinCDeX9Mmk/Mutu0IpA5SGu/nWJhGdi+d8NWHhWNLB9LnqGP14XNNgQhHSX4
	Wi7RX8aGhq0C/uBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B527B138E3;
	Tue, 21 Nov 2023 09:59:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id AULtKpN/XGWPOgAAMHmgww
	(envelope-from <pvorel@suse.cz>); Tue, 21 Nov 2023 09:59:47 +0000
Date: Tue, 21 Nov 2023 10:59:46 +0100
From: Petr Vorel <pvorel@suse.cz>
To: Amir Goldstein <amir73il@gmail.com>, ltp@lists.linux.it,
	Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org,
	Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [LTP] [PATCH 2/2] fanotify13: Test watching overlayfs with
 FAN_REPORT_FID
Message-ID: <20231121095946.GA88938@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20231114072338.1669277-1-amir73il@gmail.com>
 <20231114072338.1669277-3-amir73il@gmail.com>
 <20231114105719.GB2325395@pevik>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231114105719.GB2325395@pevik>
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -3.50
X-Spamd-Result: default: False [-3.50 / 50.00];
	 ARC_NA(0.00)[];
	 HAS_REPLYTO(0.30)[pvorel@suse.cz];
	 REPLYTO_EQ_FROM(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 RCPT_COUNT_FIVE(0.00)[5];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FREEMAIL_TO(0.00)[gmail.com,lists.linux.it,suse.cz,vger.kernel.org,szeredi.hu];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]

Hi Amir,

> Hi Amir,

> Reviewed-by: Petr Vorel <pvorel@suse.cz>
> Few notes below.

> > Run test variants watching overlayfs (over all supported fs)
> > and reporting events with fid.

> > This requires overlayfs support for AT_HANDLE_FID (kernel 6.6) and
> > even with AT_HANDLE_FID file handles, only inode marks are supported.

> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  testcases/kernel/syscalls/fanotify/fanotify.h | 28 ++++++++++++-----
> >  .../kernel/syscalls/fanotify/fanotify13.c     | 31 ++++++++++++++++---
> >  2 files changed, 47 insertions(+), 12 deletions(-)

> > diff --git a/testcases/kernel/syscalls/fanotify/fanotify.h b/testcases/kernel/syscalls/fanotify/fanotify.h
> > index 78424a350..a8aec6597 100644
> > --- a/testcases/kernel/syscalls/fanotify/fanotify.h
> > +++ b/testcases/kernel/syscalls/fanotify/fanotify.h
> > @@ -79,8 +79,11 @@ static inline int safe_fanotify_mark(const char *file, const int lineno,
> >  /*
> >   * Helper function used to obtain fsid and file_handle for a given path.
> >   * Used by test files correlated to FAN_REPORT_FID functionality.
> > + *
> > + * Returns 0 if normal NFS file handles are supported.
> > + * Returns AT_HANDLE_FID, of only non-decodeable file handles are supported.
> s/ of / if /
> I can fix this before merge.

I dared to fix this and s/AT_HADNLE_FID/AT_HANDLE_FID/ and merge.

> Also I noticed (not related to this change) that #define AT_HANDLE_FID 0x200
> added in dc7b1332ab into testcases/kernel/syscalls/fanotify/fanotify.h should
> have been in include/lapi/fanotify.h (this file is for fallback definitions).
> Tiny detail, which should be fixed afterwards.

I also merged a cleanup of the fallback definitions.

Thanks for maintaining fanotify tests!

Kind regards,
Petr

> >   */
> > -static inline void fanotify_get_fid(const char *path, __kernel_fsid_t *fsid,
> > +static inline int fanotify_get_fid(const char *path, __kernel_fsid_t *fsid,
> >  				    struct file_handle *handle)
> >  {
> >  	int mount_id;
> > @@ -93,6 +96,11 @@ static inline void fanotify_get_fid(const char *path, __kernel_fsid_t *fsid,

> >  	if (name_to_handle_at(AT_FDCWD, path, handle, &mount_id, 0) == -1) {
> >  		if (errno == EOPNOTSUPP) {
> > +			/* Try to request non-decodeable fid instead */
> > +			if (name_to_handle_at(AT_FDCWD, path, handle, &mount_id,
> > +					      AT_HANDLE_FID) == 0)
> > +				return AT_HANDLE_FID;
> > +
> >  			tst_brk(TCONF,
> >  				"filesystem %s does not support file handles",
> >  				tst_device->fs_type);
> > @@ -100,6 +108,7 @@ static inline void fanotify_get_fid(const char *path, __kernel_fsid_t *fsid,
> >  		tst_brk(TBROK | TERRNO,
> >  			"name_to_handle_at(AT_FDCWD, %s, ...) failed", path);
> >  	}
> > +	return 0;
> >  }

> >  #ifndef FILEID_INVALID
> > @@ -112,18 +121,21 @@ struct fanotify_fid_t {
> >  	char buf[MAX_HANDLE_SZ];
> >  };

> > -static inline void fanotify_save_fid(const char *path,
> > +static inline int fanotify_save_fid(const char *path,
> >  				     struct fanotify_fid_t *fid)
> >  {
> >  	int *fh = (int *)(fid->handle.f_handle);
> > +	int ret;

> >  	fh[0] = fh[1] = fh[2] = 0;
> >  	fid->handle.handle_bytes = MAX_HANDLE_SZ;
> > -	fanotify_get_fid(path, &fid->fsid, &fid->handle);
> > +	ret = fanotify_get_fid(path, &fid->fsid, &fid->handle);

> >  	tst_res(TINFO,
> >  		"fid(%s) = %x.%x.%x.%x.%x...", path, fid->fsid.val[0],
> >  		fid->fsid.val[1], fh[0], fh[1], fh[2]);
> > +
> > +	return ret;
> >  }
> >  #endif /* HAVE_NAME_TO_HANDLE_AT */

> > @@ -179,6 +191,7 @@ static inline int fanotify_events_supported_by_kernel(uint64_t mask,
> >   * @return  0: fanotify supported both in kernel and on tested filesystem
> >   * @return -1: @flags not supported in kernel
> >   * @return -2: @flags not supported on tested filesystem (tested if @fname is not NULL)
> > + * @return -3: @flags not supported on overlayfs (tested if @fname == OVL_MNT)
> >   */
> >  static inline int fanotify_init_flags_supported_on_fs(unsigned int flags, const char *fname)
> >  {
> > @@ -199,7 +212,7 @@ static inline int fanotify_init_flags_supported_on_fs(unsigned int flags, const

> >  	if (fname && fanotify_mark(fd, FAN_MARK_ADD, FAN_ACCESS, AT_FDCWD, fname) < 0) {
> >  		if (errno == ENODEV || errno == EOPNOTSUPP || errno == EXDEV) {
> > -			rval = -2;
> > +			rval = strcmp(fname, OVL_MNT) ? -2 : -3;
> >  		} else {
> >  			tst_brk(TBROK | TERRNO,
> >  				"fanotify_mark (%d, FAN_MARK_ADD, ..., AT_FDCWD, %s) failed",
> > @@ -269,10 +282,11 @@ static inline void fanotify_init_flags_err_msg(const char *flags_str,
> >  	if (fail == -1)
> >  		res_func(file, lineno, TCONF,
> >  			 "%s not supported in kernel?", flags_str);
> > -	if (fail == -2)
> > +	if (fail == -2 || fail == -3)
> >  		res_func(file, lineno, TCONF,
> > -			 "%s not supported on %s filesystem",
> > -			 flags_str, tst_device->fs_type);
> > +			 "%s not supported on %s%s filesystem",
> > +			 flags_str, fail == -3 ? "overlayfs over " : "",
> > +			 tst_device->fs_type);
> >  }

> >  #define FANOTIFY_INIT_FLAGS_ERR_MSG(flags, fail) \
> > diff --git a/testcases/kernel/syscalls/fanotify/fanotify13.c b/testcases/kernel/syscalls/fanotify/fanotify13.c
> > index 4bcffaab2..4a7c2af23 100644
> > --- a/testcases/kernel/syscalls/fanotify/fanotify13.c
> > +++ b/testcases/kernel/syscalls/fanotify/fanotify13.c
> > @@ -91,8 +91,10 @@ static struct test_case_t {

> >  static int ovl_mounted;
> >  static int bind_mounted;
> > +static int ovl_bind_mounted;
> >  static int nofid_fd;
> >  static int fanotify_fd;
> > +static int at_handle_fid;
> >  static int filesystem_mark_unsupported;
> >  static char events_buf[BUF_SIZE];
> >  static struct event_t event_set[EVENT_MAX];
> > @@ -113,8 +115,10 @@ static void get_object_stats(void)
> >  {
> >  	unsigned int i;

> > -	for (i = 0; i < ARRAY_SIZE(objects); i++)
> > -		fanotify_save_fid(objects[i].path, &objects[i].fid);
> > +	for (i = 0; i < ARRAY_SIZE(objects); i++) {
> > +		at_handle_fid |=
> > +			fanotify_save_fid(objects[i].path, &objects[i].fid);
> > +	}
> >  }

> >  static int setup_marks(unsigned int fd, struct test_case_t *tc)
> > @@ -154,6 +158,11 @@ static void do_test(unsigned int number)
> >  		return;
> >  	}

> > +	if (at_handle_fid && mark->flag != FAN_MARK_INODE) {
> > +		tst_res(TCONF, "overlayfs does not support decodeable file handles required by %s", mark->name);
> > +		return;
> > +	}
> > +
> >  	if (filesystem_mark_unsupported && mark->flag & FAN_MARK_FILESYSTEM) {
> >  		tst_res(TCONF, "FAN_MARK_FILESYSTEM not supported in kernel?");
> >  		return;
> > @@ -169,7 +178,7 @@ static void do_test(unsigned int number)
> >  		goto out;

> >  	/* Watching base fs - open files on overlayfs */
> > -	if (tst_variant) {
> > +	if (tst_variant && !ovl_bind_mounted) {
> >  		if (mark->flag & FAN_MARK_MOUNT) {
> >  			tst_res(TCONF, "overlayfs base fs cannot be watched with mount mark");
> >  			goto out;
> > @@ -191,7 +200,7 @@ static void do_test(unsigned int number)
> >  			SAFE_CLOSE(fds[i]);
> >  	}

> > -	if (tst_variant)
> > +	if (tst_variant && !ovl_bind_mounted)
> >  		SAFE_UMOUNT(MOUNT_PATH);

> >  	/* Read events from event queue */
> > @@ -288,6 +297,8 @@ static void do_setup(void)
> >  	 * Variant #0: watch base fs - open files on base fs
> >  	 * Variant #1: watch lower fs - open lower files on overlayfs
> >  	 * Variant #2: watch upper fs - open upper files on overlayfs
> > +	 * Variant #3: watch overlayfs - open lower files on overlayfs
> > +	 * Variant #4: watch overlayfs - open upper files on overlayfs
> >  	 *
> >  	 * Variants 1,2 test a bug whose fix bc2473c90fca ("ovl: enable fsnotify
> >  	 * events on underlying real files") in kernel 6.5 is not likely to be
> > @@ -295,6 +306,8 @@ static void do_setup(void)
> >  	 * To avoid waiting for events that won't arrive when testing old kernels,
> >  	 * require that kernel supports encoding fid with new flag AT_HADNLE_FID,
> s/AT_HADNLE_FID/AT_HANDLE_FID/
> (old typo)

> >  	 * also merged to 6.5 and not likely to be backported to older kernels.
> > +	 * Variants 3,4 test overlayfs watch with FAN_REPORT_FID, which also
> > +	 * requires kernel with support for AT_HADNLE_FID.
> s/AT_HADNLE_FID/AT_HANDLE_FID/
> (new typo)
> I can fix these during merge.

> Kind regards,
> Petr

> >  	 */
> >  	if (tst_variant) {
> >  		REQUIRE_HANDLE_TYPE_SUPPORTED_BY_KERNEL(AT_HANDLE_FID);
> > @@ -319,6 +332,12 @@ static void do_setup(void)
> >  	/* Create file and directory objects for testing on base fs */
> >  	create_objects();

> > +	if (tst_variant > 2) {
> > +		/* Setup watches on overlayfs */
> > +		SAFE_MOUNT(OVL_MNT, MOUNT_PATH, "none", MS_BIND, NULL);
> > +		ovl_bind_mounted = 1;
> > +	}
> > +
> >  	/*
> >  	 * Create a mark on first inode without FAN_REPORT_FID, to test
> >  	 * uninitialized connector->fsid cache. This mark remains for all test
> > @@ -337,6 +356,8 @@ static void do_cleanup(void)
> >  		SAFE_CLOSE(nofid_fd);
> >  	if (fanotify_fd > 0)
> >  		SAFE_CLOSE(fanotify_fd);
> > +	if (ovl_bind_mounted)
> > +		SAFE_UMOUNT(MOUNT_PATH);
> >  	if (bind_mounted) {
> >  		SAFE_UMOUNT(MOUNT_PATH);
> >  		SAFE_RMDIR(MOUNT_PATH);
> > @@ -348,7 +369,7 @@ static void do_cleanup(void)
> >  static struct tst_test test = {
> >  	.test = do_test,
> >  	.tcnt = ARRAY_SIZE(test_cases),
> > -	.test_variants = 3,
> > +	.test_variants = 5,
> >  	.setup = do_setup,
> >  	.cleanup = do_cleanup,
> >  	.needs_root = 1,
