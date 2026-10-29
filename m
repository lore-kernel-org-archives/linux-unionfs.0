Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.205.69.214
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793308722;
	b=wF87cwGIkq4uGG7XP2Iy+mTvZHHYdZ5OockDtrifrqVAPh/ELCTn7TVSs5RJmkxeZorL
	 AwAzASmy++0QpoYFDaTuPEM62/ZyWpY/vKft+XmWS2X+ie9IvtxGG37bPrhZo43U56t9B
	 Z8rFROXdMBbNEo9xOizmbRiTqyk8WoLhXGqYlcnQEJIaHVqf37e4L6OTfQPTBOnwd6+qD
	 Fs2/MV4P7zmZJDsA6eD/XcKCNFehyAWrBw3khkxBt3+eR4PvlsnANLoXX+wNA6PRra2UN
	 oGD2unQE3uxbFo8OvsCayXJR10yosPDHgP0AjzX/Di1OL4c3iPTfcRPDC8jmOmAfC9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793308722;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Message-ID:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Feedback-ID;
	bh=I5X+ZmPO3CQba0esVboJm4mky7PH5KkFaOsJl1sLn5g=;
	b=A/MhpgYwXlK9Ze08bLLTCxCBTmFfyPI9JrLpipBjr36i6Lg1fwo0PFcVlFtsAV+nzQ8X
	 DfaOS8kmGaCp131N++8LfoAI9kTV9/ak0dPpHusuu713zflsBYEKSP3HKalA5a2IgRbz6
	 VE67i/BUegORcVYQ0DJK0fd0Fnw+/RiJBh0vWCXRT1p4dfzAgGAl8MLG40NKecKer4KOg
	 s2Hkzu9Ouddc4+vVno5wu9am5USHkq38lnSBoOhR4rQIjRXFVpxA3CpgSzwNli874+Voh
	 Dg4Udf4kr8sfKI0rnjB3m9dd8L+icMng76UmcWFhPVIo8ADB6ROp+4bgwOFe4SmDH1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuta.io;
	spf=pass smtp.mailfrom=tuta.io;
	dkim=pass header.d=tuta.io header.i=@tuta.io header.a=rsa-sha256 header.s=s1 header.b=utQ9KhMm;
	arc=none smtp.remote-ip=185.205.69.214
Received: from mail.w14.tutanota.de (mail.w14.tutanota.de [185.205.69.214])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA3F606A31C
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 21:18:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFA3F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuta.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuta.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tuta.io header.i=@tuta.io header.a=rsa-sha256 header.s=s1 header.b=utQ9KhMm
Received: from tutadb.w10.tutanota.de (w10.api.tuta.com [IPv6:fd:ac::d:10])
	by mail.w14.tutanota.de (Postfix) with ESMTP id 5B17519EEEF84
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 22:18:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1793308720;
	s=s1; d=tuta.io;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
	bh=I5X+ZmPO3CQba0esVboJm4mky7PH5KkFaOsJl1sLn5g=;
	b=utQ9KhMmUiayjU7ShO6AXmX5GpP/0UNEEvpiSsWJQYWaqVmXR1ymstTjp4VPlWDG
	szoBccsqPpfHzCBZBt8cR3RfuN4OEVGnBc1gAekVq4e6p4e8OVoWISfwNx3F/h2HkQN
	NYMIvkt3n1hMQ8YCnkBsB5k6w8I0ZQiNscLpIQJ2A0CWONm1pEx8UCFa41DUkZ0EMsK
	OLHOytO85DZLF6GqypfCDBMBPh//J8v1Rg4b+FB3fjrshYxDC1wF5KqpwieHAoGNlA1
	jElNYjM3AMnHov5L0S6vENoAIUK8A2BzHtwMucp+e7VUO+ovL+nP1eBznUt97DPjAxM
	Vtyec9edBg==
Date: Thu, 29 Oct 2026 22:18:40 +0100 (CET)
From: Edvard Conrad <edvard@tuta.io>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Edvard Conrad <edvard@tuta.io>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Message-ID: <P58Wrer--F-9@tuta.io>
Subject: [PATCH v3] fs: let backing files inherit FMODE_NONOTIFY from the
 user file
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

When fanotify reports a permission event, copy_event_to_user() creates
the event fd with dentry_open_nonotify(), so that the listener's use of
that fd does not generate further events. If the event's path is on a
stacked filesystem, the stacked filesystem's ->open() opens the real
file with backing_file_open(). Since commit ebe559609d78 ("fs: get rid
of __FMODE_NONOTIFY kludge"), FMODE_NONOTIFY lives in f_mode only and
the backing file does not inherit it: it is allocated with the default
fsnotify mode, and fsnotify_open_perm_and_set_mode() raises FS_OPEN_PERM
on the real path if the backing filesystem has permission event
watchers.

Before that commit __FMODE_NONOTIFY travelled in f_flags, and overlayfs
copies the user file's f_flags into the backing open
(ovl_open_realfile()), so the backing file was exempt implicitly. Commit
bc2473c90fca ("ovl: enable fsnotify events on underlying real files")
relied on that when it dropped FMODE_NONOTIFY from OVL_OPEN_FLAGS.

The nested event is queued to the same group, from inside the
listener's read(2), and can only be answered by another reader thread
of that group. A listener holding filesystem marks on both the stacked
and the backing filesystem therefore deadlocks as soon as all of its
reader threads are inside such a read(2) at the same time, and every
other task that touches a marked filesystem queues up behind it.

Observed with a commercial anti-malware agent (16 reader threads) on an
ostree/composefs host: / is an overlayfs whose data layer is the ostree
object store on the same btrfs that holds /etc and /home, and a
systemd-sysext overlay sits on /usr. Every on-demand scan of /usr wedged
the whole machine until the group was killed. Stack of a blocked reader
thread on 7.2.7:

  fanotify_get_response
  fanotify_handle_event
  send_to_group
  fsnotify
  __fsnotify_parent
  do_dentry_open
  vfs_open
  backing_file_open
  ovl_open_realfile [overlay]
  ovl_open [overlay]
  do_dentry_open
  vfs_open
  backing_file_open
  ovl_open_realfile [overlay]
  ovl_open [overlay]
  do_dentry_open
  vfs_open
  dentry_open_nonotify
  copy_event_to_user
  fanotify_read
  vfs_read
  ksys_read

Userspace cannot avoid this: the backing open happens while the kernel
builds the fd, before the event is reported, and fid reporting is not
available for permission event classes.

Make a backing file inherit FMODE_NONOTIFY when the user file it is
opened for must not generate events. This restores the pre-6.14
behaviour for the fds that fanotify creates (and for any other
FMODE_NONOTIFY file), while ordinary opens through a stacked filesystem
keep generating events on the real path, as intended by bc2473c90fca.

Verified with a self-contained reproducer (private tmpfs lower layers, an
overlayfs over them, FAN_OPEN_PERM filesystem marks on the overlay and on
one lower layer, a child opening a file through the overlay) in a qemu
VM on this tree built with defconfig plus OVERLAY_FS, FANOTIFY and
FANOTIFY_ACCESS_PERMISSIONS: without this patch the listener's read(2)
never returns and the child's open is released only by the listener's
death; with it read(2) returns, the event is answered and the open
completes.

backing_tmpfile_open() is left alone: its only caller is
ovl_create_tmpfile(), whose user file is a regular overlayfs file.

Fixes: ebe559609d78 ("fs: get rid of __FMODE_NONOTIFY kludge")
Cc: stable@vger.kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Edvard Conrad <edvard@tuta.io>
---
v3:
- Back to the v1 change in backing_file_open(). The init_file()
  variant posted as v2 was larger without being more general; Amir
  withdrew that suggestion and reviewed v1 instead.
- Add Amir's Reviewed-by. Drop the Assisted-by and Suggested-by
  trailers and the blank line in the trailer block, as asked.
- Keep the subject line from v2, which is the prefix used for
  fs/backing-file.c.
- The reproducer posted inline with v1 is now an LTP test, under
  review as syscalls/fanotify26:
  https://lore.kernel.org/ltp/P50G-yE--F-9@tuta.io/

v2: https://lore.kernel.org/all/P4wV1J9--F-9@tuta.io/
v1: https://lore.kernel.org/all/P4sl5iz--F-9@tuta.io/

Tool disclosure (Documentation/process/generated-content.rst): the
stack analysis, the git-history search for the regressing commit, the
patch text, the commit message and the reproducer were produced with
an AI coding assistant (Anthropic Claude Code) under my direction over
interactive sessions; I reviewed, built and tested the result. No
static analysis tools beyond checkpatch were used.

 fs/backing-file.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 5614cb7801e..24357bf9328 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -43,6 +43,17 @@ struct file *backing_file_open(const struct file *user_file, int flags,
 	if (IS_ERR(f))
 		return f;
 
+	/*
+	 * A user file that must not generate fsnotify events (e.g. the fd
+	 * that fanotify creates for a permission event with
+	 * dentry_open_nonotify()) must not generate them through its backing
+	 * file either. Otherwise a listener watching the backing filesystem
+	 * gets a nested permission event from its own read(2), which only
+	 * another reader of the same group can answer.
+	 */
+	if (FMODE_FSNOTIFY_NONE(user_file->f_mode))
+		file_set_fsnotify_mode(f, FMODE_NONOTIFY);
+
 	path_get(user_path);
 	backing_file_set_user_path(f, user_path);
 	error = vfs_open(real_path, f);
-- 
2.56.0

