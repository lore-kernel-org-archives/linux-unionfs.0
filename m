Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.205.69.214
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793710891;
	b=c4ksIQAOF3ReoYZx39PSDLS3fqUoev7iwcGOCMueLHEiH4jGucjVxaW0EWAf1opXetVk
	 cfTQmgA2PVcV5ihHiKZ5zM2jKN9/7DgwE84OwzXWT9EjPW8K9QGhaix8J9nfu/T2OQjiM
	 UaXXAePobXZjyqYAnPMpnB9/2yryV5yluzCshZPgFOPlD/6g90J69cHtcRcw5hAR12S0L
	 MQdAIjFZVgZzaw/InrAlLDmHwR89w5NFTJBHyE+tYCNRpMMD+7nQMhKGybc4kx5TgBL7J
	 X3rOPbhT5M7PFsNZts/8QBngq2+OGeVKZ717Egk/AxDYQYRGeYjHr9UpIA33ef4LcDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793710891;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Message-ID:
	 In-Reply-To:References:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Feedback-ID;
	bh=DzJkftSALHxewxovsf7uhxAhrTSplWGmkUOlhUCVnSY=;
	b=KlYu+2M2uZsqapUp6j0kly9ZMuYaXTjjypQVTjPxczJy4vjpXblUzB2MehEpnEs26GQL
	 +Xt096ZsAOs0ZxOILU7jbfD1EIgllp02+y22FXoMh/SwXk3R5xWarEfox+LcvRo+5X456
	 6MCYBREvqfVRHF2S+9wO3Vu8ViGyi48tCxCo7I8cCQMyRutq/AYHwo69HRMsHMCUhkhV5
	 BuSvLdt2QQaMwa2MU8UzDfPc8ej/aJMNBjitzV7iB/EFPkofuIQMeIsFUCZoY4k3mRRz1
	 PigiGBpgISZ/caRLEOALGQpiJTTND9cfDC61vtw0+8c3gtw9Me6ql7lEO7xIEjrNwjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuta.io;
	spf=pass smtp.mailfrom=tuta.io;
	dkim=pass header.d=tuta.io header.i=@tuta.io header.a=rsa-sha256 header.s=s1 header.b=eqf2TMyy;
	arc=none smtp.remote-ip=185.205.69.214
Received: from mail.w14.tutanota.de (mail.w14.tutanota.de [185.205.69.214])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24CE606A327
	for <linux-unionfs@vger.kernel.org>; Tue,  3 Nov 2026 13:01:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C24CE606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuta.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuta.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tuta.io header.i=@tuta.io header.a=rsa-sha256 header.s=s1 header.b=eqf2TMyy
Received: from tutadb.w10.tutanota.de (w10.api.tuta.com [IPv6:fd:ac::d:10])
	by mail.w14.tutanota.de (Postfix) with ESMTP id 49FE11A1AF133
	for <linux-unionfs@vger.kernel.org>; Tue,  3 Nov 2026 14:01:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1793710889;
	s=s1; d=tuta.io;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:References:Sender;
	bh=DzJkftSALHxewxovsf7uhxAhrTSplWGmkUOlhUCVnSY=;
	b=eqf2TMyy3+mkJV/+c2wc0t8K4Dsg3aTKCPu/QKrEb6Sy93dJzgwWGLKBKeRFNySQ
	6jEO1djZau3Q+nVjseWdLD6m+huqxCExAndgKZv063DmmyYRsvMMqCcmpnHFaJiHL6Y
	T4uhHO0xsa3rcstdpEuNw8acVLNvkVJYZPis6L9FqVv5aWyFCAMIW28bFR6ckZRrJpc
	TFm3uDuwL/iIANsXgMujVaDL9eS6j1gDwdc+RTGPsxPTv+AGmw+7pv/rmVM/cUD1KY/
	M+t7uJDMEEFhy/q5x1bIHBqxNRQLNB6AvaHsA85pkZuwHNfdZZmaVaXvvCpX3amAixq
	h9RI8/NdJg==
Date: Tue, 3 Nov 2026 14:01:29 +0100 (CET)
From: Edvard Conrad <edvard@tuta.io>
To: Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Edvard Conrad <edvard@tuta.io>
Message-ID: <P5WV0VL--F-9@tuta.io>
In-Reply-To: <CAOQ4uxh67+vs0mr-Lxmwz9-N+F8m29WUNz+8qFLLDpOVYB7=vg@mail.gmail.com>
References: <P58Wrer--F-9@tuta.io> <20261030-welpen-anbinden-nullen-b2432cee1d10@brauner> <CAOQ4uxjm=cGPnug18VuhKqiMvkWwLPNLO_TE3KxO8iLZG+veYQ@mail.gmail.com> <P5Qu3co--N-9@tuta.io> <CAOQ4uxh67+vs0mr-Lxmwz9-N+F8m29WUNz+8qFLLDpOVYB7=vg@mail.gmail.com>
Subject: Re: [PATCH v3] fs: let backing files inherit FMODE_NONOTIFY from
 the user file
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Feedback-ID: 0127f977f5e13e8051b46c6e7f57d0f95a0470d24b79d7c31d07fdf611cc427ab823e0f4692a810119c92d8768973a9281:TurnOnPrivacy!:tutamail

On Mon, Nov 2, 2026 at 1:34 PM Amir Goldstein <amir73il@gmail.com> wrote:
> Good catch!
> Please test the attached v2 patch and post the new test cases.

v2 fixes the merged directory. An impure directory still deadlocks the
same way: ovl_iterate_real() reads it through ovl_cache_get_impure() and
ovl_dir_read_impure(), which v2 leaves without the user file, so
ovl_dir_read() opens the upper directory with plain ovl_path_open():

  fanotify_handle_event
  fsnotify
  fsnotify_open_perm_and_set_mode
  do_dentry_open
  vfs_open
  dentry_open
  ovl_iterate_real
  ovl_iterate
  iterate_dir
  __x64_sys_getdents64

That takes an upper-only directory that a lower file was renamed into,
on layers that share a filesystem, so ovl_need_adjust_d_ino() sends it
to ovl_iterate_real(). Passing the file down the same way v2 does for
the merged case fixes it for me, on top of v2:

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -670,7 +670,7 @@ static bool ovl_fill_plain(struct dir_context *ctx, const char *name,
 }
 
 static int ovl_dir_read_impure(const struct path *path,  struct list_head *list,
-			       struct rb_root *root)
+			       struct rb_root *root, const struct file *user_file)
 {
 	int err;
 	struct path realpath;
@@ -678,6 +678,7 @@ static int ovl_dir_read_impure(const struct path *path,  struct list_head *list,
 	struct ovl_readdir_data rdd = {
 		.ctx.actor = ovl_fill_plain,
 		.ctx.count = INT_MAX,
+		.user_file = user_file,
 		.list = list,
 		.root = root,
 	};
@@ -714,9 +715,10 @@ static int ovl_dir_read_impure(const struct path *path,  struct list_head *list,
 	return 0;
 }
 
-static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *path)
+static struct ovl_dir_cache *ovl_cache_get_impure(struct file *file)
 {
 	int res;
+	const struct path *path = &file->f_path;
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = d_inode(dentry);
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
@@ -735,7 +737,7 @@ static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *path)
 		return ERR_PTR(-ENOMEM);
 
 	cache->is_refcounted = false;
-	res = ovl_dir_read_impure(path, &cache->entries, &cache->root);
+	res = ovl_dir_read_impure(path, &cache->entries, &cache->root, file);
 	if (res) {
 		ovl_cache_free(&cache->entries);
 		kfree(cache);
@@ -856,7 +858,7 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	dput(parent);
 
 	if (ovl_is_impure_dir(file)) {
-		rdt.cache = ovl_cache_get_impure(&file->f_path);
+		rdt.cache = ovl_cache_get_impure(file);
 		if (IS_ERR(rdt.cache))
 			return PTR_ERR(rdt.cache);
 	}

Results in a VM on 6b4b543fa18, each kernel run once and with -i 2,
with the backing filesystem marked:

                                file  dir   merged dir  impure dir
                                            listed      listed
  + c3d355f427ce                PASS  FAIL  FAIL        FAIL
  + your v1                     PASS  PASS  FAIL        FAIL
  + your v2                     PASS  PASS  PASS        FAIL
  + v2 and the diff above       PASS  PASS  PASS        PASS

The new cases are posted on top of the directory cases:
  https://lore.kernel.org/ltp/P5WKBbq--F-9@tuta.io/

Thanks,
Edvard
