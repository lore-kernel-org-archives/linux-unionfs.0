Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751372;
	b=cJgffKML2vovNFdCDbqH9PNAZ6TnUWn2NZIWYvzlHWgpbRyhs6FBXsXbzNrXaTmFD9Zc
	 pG7/pvklY0vsI0s9PL5Kwzfb693j511DSRAzWbpy7hTqyvgQbZhAtiDpt21E7pFMxoVjJ
	 Z9gkmiSCL/inXNN1SSyGUYUFE4mGZ/kHYZ31kFBVeuAiQJpj1nVXCtt9Fy3Z2W8y7zKoQ
	 fWKHxJnBYegC05KLYLyYtrMuzRw9PHyIZZxhiemKScIKnTzbllCbDuMIHb2QpFODBFxO1
	 6+KWDPz61+hcz0wqw7U++orgOwDEV8OBuAPX3UWCzb+DV6pwcY2kyyyws9NHKQTXiYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751372;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=yN6Rkl1L43xto0GNjrkTF/h2UW8ZoyBlI4+dV6PL+Zk=;
	b=LhKL81/LuovzZrJjgmG+N6K3ITBeByOyRSMU6DuczOKAEj0nuhRWwq7Q9IVcINywhXYu
	 4QWZzrSwOtzDy1yf1q1KP2tAo1LmO6tiAwBBVhL96F+uCcF/2wWrx/3IoNJJffTZuFVV2
	 dJjZRa0Y12BcHJ4nuay17z/PHxVNM8JqvqM+T2sUbTOutP2yntMQRUcSJIXtrui4Eot74
	 TvxEhVmOG6mcktbIEs/uVBDDr4E1yKlPV2Wm3YT3P3eUO2JruEvWPYP94gXq/Fl400c0S
	 EkPRfdS7grpx2OiqwjnZxClykKGrt260fk9Vl+BqeFDTvYINKSIrcTfdGlpRI/En/XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=loi3I3vF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7782B60A5BDA;
	Sun, 15 Nov 2026 14:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=loi3I3vF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5F81F000D0;
	Sun, 15 Nov 2026 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751372;
	bh=yN6Rkl1L43xto0GNjrkTF/h2UW8ZoyBlI4+dV6PL+Zk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=loi3I3vFq+MyTChzl8YT0jBGhMXooxkatMOHR86+J+u++wcuW7IIzsnDM3JjhuP0R
	 EwHZUaxyqnPmAQ8fVGccDau0JxuuXn1NIvb8aeUlLf8GALcRJadoYipeGyJC768sT+
	 r+n94ZI/eou3KAW12cBOezTA4fMdBkNF29M24p56GarMJvaSKjv3tJz1PEJJUbEx6L
	 QM4XEnIh6veBo2MPetAikOA5Jko9ugwSblmYiFPM8wCcVpk+pSAuQ1Q0a9IV516ifU
	 jdtlk2fw2YHQMB3ZprPsJ63AUAlbKK21hmI8gUY7Nk5kqARKErvDe4EmFxP0Y8JAC2
	 Ga6XCuraqzT0g==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:43 +0100
Subject: [PATCH 13/13] selftests/bpf: add uprobe_multi test on overlayfs
 without data
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-13-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5550; i=brauner@kernel.org;
 h=from:subject:message-id; bh=s/2BR6vApkMwUflb/E75PK0IMgv+kNCBTrkxznLRTiM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B3HtVQj9M+7kF7d2o8Wv34t5J/z5q2u4bWgrefVJ
 v1UzYz81FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR218Y/pelXXPurtlcsa0l
 u2tR1xMmvjQNNoaFvZUPNFkW3s6dsZXhf8LC/R77J0dVLGKdPetqkeyeX3wCL2feWvcnrW5TjHn
 cSTYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add a uprobe_multi test that attaches to a metacopy file on overlayfs
whose redirect into a data-only layer points at nothing:

- the overlayfs is set up in a child in its own mount namespace

- BPF_LINK_CREATE must fail with ENOENT from the lazy lowerdata lookup

- skip if overlayfs with data-only layers isn't available

Before d_real() could fail this got an EIO from uprobe_register().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../selftests/bpf/prog_tests/uprobe_multi_test.c   | 141 +++++++++++++++++++++
 1 file changed, 141 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
index 7fbcfddc3cc36..907d8c6d5ec93 100644
--- a/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
@@ -3,6 +3,10 @@
 #include <unistd.h>
 #include <pthread.h>
 #include <fcntl.h>
+#include <sched.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/xattr.h>
 #include <test_progs.h>
 #include "uprobe_multi.skel.h"
 #include "uprobe_multi_bench.skel.h"
@@ -575,6 +579,141 @@ static void test_attach_api_fails(void)
 	uprobe_multi__destroy(skel);
 }
 
+enum ovl_no_data_stage {
+	OVL_NO_DATA_SETUP,
+	OVL_NO_DATA_MOUNT,
+	OVL_NO_DATA_ATTACH,
+};
+
+struct ovl_no_data_result {
+	enum ovl_no_data_stage stage;
+	int err;
+};
+
+/*
+ * Runs in a child in its own mount namespace. Create an overlayfs with a
+ * metacopy file whose redirect into a data-only layer points at nothing
+ * and try to attach to it.
+ */
+static void ovl_no_data_child(int prog_fd, const char *dir, int wfd)
+{
+	struct ovl_no_data_result res = { .stage = OVL_NO_DATA_SETUP };
+	LIBBPF_OPTS(bpf_link_create_opts, opts);
+	char path[PATH_MAX], data[PATH_MAX * 2 + 32];
+	unsigned long offset = 0;
+	int fd;
+
+	if (unshare(CLONE_NEWNS) ||
+	    mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL) ||
+	    mount("tmpfs", dir, "tmpfs", 0, NULL))
+		goto out_errno;
+
+	snprintf(path, sizeof(path), "%s/lower", dir);
+	if (mkdir(path, 0755))
+		goto out_errno;
+	snprintf(path, sizeof(path), "%s/data", dir);
+	if (mkdir(path, 0755))
+		goto out_errno;
+	snprintf(path, sizeof(path), "%s/merged", dir);
+	if (mkdir(path, 0755))
+		goto out_errno;
+
+	snprintf(path, sizeof(path), "%s/lower/f", dir);
+	fd = open(path, O_CREAT | O_WRONLY, 0755);
+	if (fd < 0)
+		goto out_errno;
+	close(fd);
+	if (setxattr(path, "trusted.overlay.metacopy", "", 0, 0) ||
+	    setxattr(path, "trusted.overlay.redirect", "/missing",
+		     strlen("/missing"), 0))
+		goto out_errno;
+
+	res.stage = OVL_NO_DATA_MOUNT;
+	snprintf(data, sizeof(data), "lowerdir=%s/lower::%s/data", dir, dir);
+	snprintf(path, sizeof(path), "%s/merged", dir);
+	if (mount("overlay", path, "overlay", 0, data))
+		goto out_errno;
+
+	res.stage = OVL_NO_DATA_ATTACH;
+	snprintf(path, sizeof(path), "%s/merged/f", dir);
+	opts.uprobe_multi.path = path;
+	opts.uprobe_multi.offsets = &offset;
+	opts.uprobe_multi.cnt = 1;
+	res.err = bpf_link_create(prog_fd, 0, BPF_TRACE_UPROBE_MULTI, &opts);
+	if (res.err >= 0)
+		close(res.err);
+	goto out;
+
+out_errno:
+	res.err = -errno;
+out:
+	if (write(wfd, &res, sizeof(res)) != sizeof(res))
+		_exit(1);
+	_exit(0);
+}
+
+/*
+ * The data of a metacopy file in an overlayfs data-only layer is looked up
+ * lazily. If it can't be found attaching must fail with the error from the
+ * lookup.
+ */
+static void test_attach_api_fails_ovl_no_data(void)
+{
+	struct ovl_no_data_result res = {};
+	char dir[] = "/tmp/uprobe_multi_ovl.XXXXXX";
+	struct uprobe_multi *skel = NULL;
+	int pipefd[2] = { -1, -1 };
+	int status, prog_fd;
+	ssize_t n;
+	pid_t pid;
+
+	skel = uprobe_multi__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "uprobe_multi__open_and_load"))
+		return;
+	prog_fd = bpf_program__fd(skel->progs.uprobe_extra);
+
+	if (!ASSERT_OK_PTR(mkdtemp(dir), "mkdtemp"))
+		goto cleanup;
+	if (!ASSERT_OK(pipe(pipefd), "pipe"))
+		goto cleanup_dir;
+
+	pid = fork();
+	if (!ASSERT_GE(pid, 0, "fork"))
+		goto cleanup_pipe;
+	if (pid == 0) {
+		close(pipefd[0]);
+		ovl_no_data_child(prog_fd, dir, pipefd[1]);
+	}
+
+	close(pipefd[1]);
+	pipefd[1] = -1;
+	n = read(pipefd[0], &res, sizeof(res));
+	if (!ASSERT_EQ(waitpid(pid, &status, 0), pid, "waitpid"))
+		goto cleanup_pipe;
+	if (!ASSERT_EQ(n, sizeof(res), "read result"))
+		goto cleanup_pipe;
+
+	if (res.stage == OVL_NO_DATA_MOUNT) {
+		printf("%s:SKIP: overlayfs with data-only layers not available (%d)\n",
+		       __func__, res.err);
+		test__skip();
+		goto cleanup_pipe;
+	}
+	if (!ASSERT_EQ(res.stage, OVL_NO_DATA_ATTACH, "setup"))
+		goto cleanup_pipe;
+	ASSERT_EQ(res.err, -ENOENT, "link_create");
+
+cleanup_pipe:
+	if (pipefd[0] >= 0)
+		close(pipefd[0]);
+	if (pipefd[1] >= 0)
+		close(pipefd[1]);
+cleanup_dir:
+	rmdir(dir);
+cleanup:
+	uprobe_multi__destroy(skel);
+}
+
 #ifdef __x86_64__
 noinline void uprobe_multi_error_func(void)
 {
@@ -1452,6 +1591,8 @@ void test_uprobe_multi_test(void)
 		test_bench_attach_usdt();
 	if (test__start_subtest("attach_api_fails"))
 		test_attach_api_fails();
+	if (test__start_subtest("attach_api_fails_ovl_no_data"))
+		test_attach_api_fails_ovl_no_data();
 	if (test__start_subtest("attach_uprobe_fails"))
 		test_attach_uprobe_fails();
 	if (test__start_subtest("consumers"))

-- 
2.53.0

