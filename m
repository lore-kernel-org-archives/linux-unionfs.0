Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.205.69.214
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793027504;
	b=3xcBBUCrJUgV11GozUr5VEJGC4UPbjicfQoVUwyEUCrO0IowT4cUqRx03KuAnjzZ+Kkr
	 chLbSSHRCwP+l89jJaBe3I/rDpcOM1kt+djJczNzAfr0uAHQJSmrqm4V2iYMIpFAPWUo9
	 tUcAZ8sMnEYDwdeX3yjkb1w4d6NqgXEHeQlsVnmjkpcmMWo+fYo3EE8SytaFdVqWQOSn9
	 N/7kMKMfHIZ2EwEoLcfucohk7Zit47qyZEBbxdwa3iX0+4KFnc1wp7uSRSI/JLv2OPA3S
	 rfNc3h0ReI3IOxDZ+fKZwH1sbiEmnEATyh2MgztRLSy2rmOvEqu1LgOa8wVoWQZVhtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793027504;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Message-ID:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Feedback-ID;
	bh=/ivERoUupObsLObOY8I61m67+JgFT7iDkgFHt9WK8EA=;
	b=VaQkDg+WfYyCzywEWucslFTsb295zPBe2NCV48nTwfobW7li69JEXxsSjW53y5CrjHB+
	 cCQ6KmTaHNHHO8J84zipUMA4AR/DOobVmgudNAig3hUgMRKDZml4jNbizKALGoUBNWRoz
	 d+HA06TzejtdrfxkIlOqL2daWl3fN+nqh3xaj4uff2vTrKNUmxrGqYuIqK+AflL/wUIQo
	 EmB2cWFfCLJaBvJcHehy2Hde+MUkyoHhEtRqPtEbBMFHGQAfDdEDgzdL2Tx21ax7gtTwP
	 7jW596sehzJx2CpIIKM9E2ku7wkD1wpSiPzYhqiLwa5Vg5B1zQw6ZvNdpbF7l1XSejA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuta.io;
	spf=pass smtp.mailfrom=tuta.io;
	dkim=pass header.d=tuta.io header.i=@tuta.io header.a=rsa-sha256 header.s=s1 header.b=RVuGkrA1;
	arc=none smtp.remote-ip=185.205.69.214
Received: from mail.w14.tutanota.de (mail.w14.tutanota.de [185.205.69.214])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA0A606A31D
	for <linux-unionfs@vger.kernel.org>; Mon, 26 Oct 2026 15:11:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FA0A606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tuta.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuta.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tuta.io header.i=@tuta.io header.a=rsa-sha256 header.s=s1 header.b=RVuGkrA1
Received: from tutadb.w10.tutanota.de (w10.api.tuta.com [IPv6:fd:ac::d:10])
	by mail.w14.tutanota.de (Postfix) with ESMTP id AE8F219CB4C5D
	for <linux-unionfs@vger.kernel.org>; Mon, 26 Oct 2026 16:11:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1793027501;
	s=s1; d=tuta.io;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
	bh=/ivERoUupObsLObOY8I61m67+JgFT7iDkgFHt9WK8EA=;
	b=RVuGkrA15cnRZqlxDne9XUO6/qiLWsydQvfbKSybkm8YFo9maXKPaPvwsAdfYy+J
	3iGOUO6bdKwbIcKRvgQkmpKZiAtq2EGltkPHHQ/ernGqjsi0J73IViEhFv8MGiGfn/k
	mIm0AJ5FTpr3s1CigCB8DHcYgbyOaawWaMlkTA1qZj3QazuMpPK91wi6bVWS2F/iiZF
	p/HceNJdQVITH7PMwtZvEGhPO58mxc9XWvGU/twk+29UNv2t7/UoPq70ZQZJHiaNNTY
	IwQLiAnVWuifOT7ek7lYCdha9UPbHJtpltsSQjD5fsA9DYBVDCx0CKsDjGulUBmsDqb
	8Pd7MeoZzw==
Date: Mon, 26 Oct 2026 16:11:41 +0100 (CET)
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
Message-ID: <P4sl5iz--F-9@tuta.io>
Subject: [PATCH] backing-file: inherit FMODE_NONOTIFY from the user file
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
Content-Transfer-Encoding: quoted-printable
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

Assisted-by: LLM
Signed-off-by: Edvard Conrad <edvard@tuta.io>
---
Reproducer: nested-perm-repro.c (inline below). It unshares a mount
namespace, mounts two private tmpfs and an overlayfs over them, puts
FAN_OPEN_PERM filesystem marks on the overlay and on one tmpfs, and lets
a child open a file through the overlay. On an unpatched 6.14+ kernel
the listener's read(2) never returns (the kernel raises a second
permission event for the backing file while creating the event fd); with
this patch it returns and the child's open completes. Verified in a qemu
VM on a defconfig+overlayfs+fanotify build of this tree, before and
after the patch (x86_64 defconfig plus OVERLAY_FS, FANOTIFY and
FANOTIFY_ACCESS_PERMISSIONS). Also observed in production: Bitdefender
BEST with filesystem marks on the btrfs that holds the ostree object
store and on a systemd-sysext overlay over /usr, Fedora kernel 7.2.7, on
a bootc/composefs host; every scan of /usr wedged the machine until the
group was killed. Full SysRq-w dumps available on request.

Tool disclosure (Documentation/process/generated-content.rst): the stack
analysis, the git-history search for the regressing commit, the patch
text, the commit message and the reproducer were produced with an AI
coding assistant (Anthropic Claude Code) under my direction over
interactive sessions; I reviewed, built and tested the result. No static
analysis tools beyond checkpatch were used.

nested-perm-repro.c:

/*
 * nested-perm-repro.c =E2=80=94 fanotify permission event raised by the ke=
rnel's own
 * event-fd creation on a stacked filesystem (overlayfs), deadlocking a lis=
tener
 * with a single reader thread. Self-contained: builds a private tmpfs + ov=
erlay
 * stack inside a new mount namespace, touches nothing else on the system.
 *
 *   gcc -O2 -Wall -o nested-perm-repro nested-perm-repro.c
 *   sudo ./nested-perm-repro
 *
 * What it does:
 *   1. unshare(CLONE_NEWNS); mount tmpfs A and tmpfs B; create A/file;
 *      mount overlay M with lowerdir=3DA:B (read-only overlay, no upper ne=
eded).
 *   2. fanotify group (FAN_CLASS_CONTENT) with FAN_OPEN_PERM *filesystem* =
marks
 *      on M (the stacked fs) and on A (the backing fs) =E2=80=94 the shape=
 of an
 *      anti-malware agent watching both the OS tree and the disk it lives =
on.
 *      Filesystem marks, not mount marks: overlayfs opens its layers throu=
gh
 *      private clones of the lower mounts, which a mount mark never matche=
s.
 *      Each tmpfs is its own superblock, so the marks touch nothing else.
 *   3. fork: the child opens M/file. That raises an OPEN_PERM event on M.
 *   4. The parent read()s the event. The kernel builds the event fd with
 *      dentry_open_nonotify() -> ovl_open() -> backing_file_open() on A/fi=
le.
 *      On kernels >=3D 6.14 without the fix, that inner open raises a SECO=
ND
 *      OPEN_PERM event on A, queued to the same group, from inside read(2)=
.
 *      With one reader thread nobody can read it: read() never returns.
 *   5. The parent dies on alarm(TIMEOUT) (SIGALRM, default action; the sle=
ep is
 *      TASK_KILLABLE so the fatal signal gets through). Closing the group
 *      answers everything FAN_ALLOW; the child's open completes and report=
s
 *      how long it was blocked: >=3D TIMEOUT means REPRODUCED.
 *
 * Expected output on an affected kernel:
 *   parent: read() on the fanotify fd ...
 *   child : open took 3.0 s (unblocked only by the listener's death) -> BU=
G REPRODUCED
 * On a fixed kernel the read returns at once, the parent answers FAN_ALLOW=
,
 * and the child reports a few milliseconds -> not reproduced.
 */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sched.h>
#include <signal.h>
#include <time.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/fanotify.h>

#define TIMEOUT 3
#define BASE "/tmp/nested-perm-repro"

static void die(const char *what)
{
    fprintf(stderr, "%s: %s\n", what, strerror(errno));
    exit(1);
}

static double now(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec / 1e9;
}

int main(void)
{
    char a[128], b[128], m[128], file[160], opts[512];
    int fan, fd;
    pid_t child;

    snprintf(a, sizeof a, "%s/A", BASE);
    snprintf(b, sizeof b, "%s/B", BASE);
    snprintf(m, sizeof m, "%s/M", BASE);
    snprintf(file, sizeof file, "%s/file", m);

    /* 1. private mount namespace + the stack */
    if (unshare(CLONE_NEWNS) < 0) die("unshare(CLONE_NEWNS)");
    if (mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL) < 0) die("make-rp=
rivate /");
    mkdir(BASE, 0755);
    mkdir(a, 0755); mkdir(b, 0755); mkdir(m, 0755);
    if (mount("tmpfs", a, "tmpfs", 0, "size=3D1m") < 0) die("mount tmpfs A"=
);
    if (mount("tmpfs", b, "tmpfs", 0, "size=3D1m") < 0) die("mount tmpfs B"=
);
    {
        char p[160];
        snprintf(p, sizeof p, "%s/file", a);
        fd =3D open(p, O_WRONLY | O_CREAT, 0644);
        if (fd < 0) die("create A/file");
        (void)!write(fd, "hello\n", 6);
        close(fd);
    }
    snprintf(opts, sizeof opts, "lowerdir=3D%s:%s", a, b);
    if (mount("overlay", m, "overlay", 0, opts) < 0) die("mount overlay M")=
;
    printf("stack : %s =3D overlay(lowerdir=3DA:B), A and B are private tmp=
fs\n", m);

    /* 2. the listener: one group, permission marks on the stacked AND the =
backing mount */
    fan =3D fanotify_init(FAN_CLASS_CONTENT | FAN_CLOEXEC, O_RDONLY | O_CLO=
EXEC);
    if (fan < 0) die("fanotify_init");
    if (fanotify_mark(fan, FAN_MARK_ADD | FAN_MARK_FILESYSTEM, FAN_OPEN_PER=
M, AT_FDCWD, m) < 0)
        die("fanotify_mark M");
    if (fanotify_mark(fan, FAN_MARK_ADD | FAN_MARK_FILESYSTEM, FAN_OPEN_PER=
M, AT_FDCWD, a) < 0)
        die("fanotify_mark A");
    printf("marks : FAN_OPEN_PERM filesystem marks on M (stacked) and A (ba=
cking)\n");

    /* 3. the victim */
    child =3D fork();
    if (child < 0) die("fork");
    if (child =3D=3D 0) {
        double t0, dt;
        int rc;

        close(fan);
        usleep(200 * 1000);
        t0 =3D now();
        rc =3D open(file, O_RDONLY);
        dt =3D now() - t0;
        if (rc >=3D 0) close(rc);
        if (dt >=3D TIMEOUT - 0.5)
            printf("child : open took %.1f s (unblocked only by the listene=
r's death) "
                   "-> BUG REPRODUCED: the listener's read() never returned=
\n", dt);
        else
            printf("child : open took %.3f s (rc=3D%d) -> not reproduced\n"=
, dt, rc);
        _exit(0);
    }

    /* 4. one read(). On an affected kernel this never returns. */
    printf("parent: read() on the fanotify fd (dies on alarm after %d s if =
it hangs) ...\n",
           TIMEOUT);
    fflush(stdout);
    alarm(TIMEOUT);
    {
        char buf[4096];
        ssize_t n =3D read(fan, buf, sizeof buf);
        struct fanotify_event_metadata *md =3D (struct fanotify_event_metad=
ata *)buf;
        struct fanotify_response resp;

        alarm(0);
        if (n <=3D 0) die("read");
        printf("parent: got event mask=3D%#llx fd=3D%d pid=3D%d =E2=80=94 r=
ead() returned, answering ALLOW\n",
               (unsigned long long)md->mask, md->fd, md->pid);
        resp.fd =3D md->fd;
        resp.response =3D FAN_ALLOW;
        (void)!write(fan, &resp, sizeof resp);
        if (md->fd >=3D 0) close(md->fd);
    }
    close(fan);
    waitpid(child, NULL, 0);
    return 0;
}

 fs/backing-file.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 5614cb7801e..24357bf9328 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -43,6 +43,17 @@ struct file *backing_file_open(const struct file *user_f=
ile, int flags,
 =09if (IS_ERR(f))
 =09=09return f;
=20
+=09/*
+=09 * A user file that must not generate fsnotify events (e.g. the fd
+=09 * that fanotify creates for a permission event with
+=09 * dentry_open_nonotify()) must not generate them through its backing
+=09 * file either. Otherwise a listener watching the backing filesystem
+=09 * gets a nested permission event from its own read(2), which only
+=09 * another reader of the same group can answer.
+=09 */
+=09if (FMODE_FSNOTIFY_NONE(user_file->f_mode))
+=09=09file_set_fsnotify_mode(f, FMODE_NONOTIFY);
+
 =09path_get(user_path);
 =09backing_file_set_user_path(f, user_path);
 =09error =3D vfs_open(real_path, f);
--=20
2.56.0

