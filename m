Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794456847;
	b=E1QjjImoz5QOTuDEB81niIkC5bw98ipHvu8HG+bg5XDSekm7OMpCJEla8uTj2R48pJTK
	 E2rI6w5FBLBjdWdWNtSfURux8Y+GwEgAlxcqheywYIffJBCAHHw/8vjnHKkPjE+FeOpvl
	 Lsp2liHD3ttFqPxKfJkEj+eS0qWsjxL6khsRB5okuP3aFIhzOzsv6GYOy6Q9/+cmfFlla
	 01LCaPIRtROY5U9XXM9lYnKstG2r/upGEu6arWCRKqI0N5rjqqAcrBtJNM4DDfmgttalz
	 TQA4hY9lmltaIudxxLJ5zcwyoNplue2eEOLhiiYfFhuqJ4XKw2J/SM1EXRKmwPJ2EcQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456847;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=YD1w0JeXcR4tiwXqnCZLuBqyW8EuNSACWiyRzXaRl2Y=;
	b=xRHfPFLidkWmC4Z4Siyzv0l9WC95zEsvZKrGWOnHkuAZ1Qf23rpVspcBCiOzw/tksbe9
	 wbl3t7wV3yrsRb++hPzR0zStps3+gsB0A4NGTtFzCGNKItPeD1Vtw3AaFWmevSLH4Giid
	 7Kf5Rfp4t3u0Xdhm20HC1vfQRzphTzZ/ZdT/iMsoW5koP3QfKTAqMpe12Zkqg+SL8Qsyg
	 iUaZfAMef9aJKh1jEliEBBFIeTGcfefgP03DXf1WDH9yX2NSB0etN54MBtDE0FXTMLTWZ
	 AUfzoZvc+Y75HECe1FXgg0QBumx40UKFuUW4oNyQ4w4d9UlrvFInQyzbbcbDD7QyO2w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lhgeE/Pq";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886F3606A88D;
	Thu, 12 Nov 2026 04:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lhgeE/Pq
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794456847;
	b=WC+ZNY36fUiFa2ca+i2TxE/rJFfEJP0BviilaKFrcattylY7iKbpQdrb2DBUFrirTZFW
	 QSBHksY72MOSssbQAx7IZCZTqE1aIpqj6eyrbD/h1K36PF9rCaOuXogy+A/NvsGZZCzy5
	 X4t8FeWQ5IQOyqIoa33mCrf/zbdBI0AZzb6Q1JR4+Lp03XHFYI8AwABRptIak8gyZ9SSZ
	 /xZIzcFNQaNE+AdUY2+CTkBG18zAUbPSnDATPXDqy09pAMY5ocgYLST7dA9605fMpRWzw
	 rcuKV7FgW3nPRk8iaaLlXvpS2KPHxF6EyEeS+qXtZrgJf+SUtkeVY78lKmQ4HEsMabA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794456847;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=YD1w0JeXcR4tiwXqnCZLuBqyW8EuNSACWiyRzXaRl2Y=;
	b=MCn3dfSfcCb0oKdadCZy+Y3UJShPXGbd2lod4vEh3mV10JgH74lvsNfbYN/y2ALxOYlI
	 6qZCb1rMTfjRC4go4xv9tPGTkdsM7prwhqrPq/iXJ9R4qbrEQPVUxQgI4SwvTnDsMJQEt
	 ZR5PrmmIitT2oYHCJuWD2FADFSFwlxq39uWZlX/PpGqgt5lfc02nTDhASnbAvU5aROJFb
	 TaANlpWmPZTIXZ0a0WkiBhaL1RDUq3jHXVg8GrHwZdzkWJ7vwLc/pcBH4RLpIZv/JvBnf
	 S250tIimTr2t6fvHaM5b8ZEVFSJnhfOOWrJ1T0pouZmDWVdZ4IEWwXuerD07rDppwzA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 976D41F00A0A;
	Thu, 12 Nov 2026 04:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794456847;
	bh=YD1w0JeXcR4tiwXqnCZLuBqyW8EuNSACWiyRzXaRl2Y=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=lhgeE/PqSmTUUQi3kIXmS1is6IABUzWtawpbw51X3IgF7DwwfLC8lWLyGFY2rRxvb
	 EC8JbBQRUVQoIgoAAnWauAJk3MLX2tW6rM2DjcL5J397TXE7ZAhCYOe7j8Rf2B2Iug
	 oCl+q/5KS68IkELDLeToBYho2WnLwlrf4NAiWgASfJmcW3AuIBEk5CDnAAtj2hW3pw
	 SMYmWL7TB8d8Qzj+/jtYCSd4wS56xwswej5tEYHonnbM/akKO5+ebLHsmDHs4306AZ
	 slYwL8hTfIHqWMQPa9UfSaUPv5Ej3ORaZAvfT/P2DHdcvvRI/rqmzYQt6BPUK1Psjz
	 9KMKwe4gCr5Xg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2320F4927F;
	Thu, 12 Nov 2026 04:14:06 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 12 Nov 2026 13:14:06 +0900
Subject: [PATCH v2] src/t_dir_offset2: do not check d_ino of a stale first
 entry
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
Message-Id: <20261112-ovl077-stale-next-v2-1-6d3a691a92df@samsung.com>
X-B4-Tracking: v=1; b=H4sIAA099WoC/32NQQ6CMBBFr0Jm7RimgoAr72FYTHCAJtCaDjYYw
 t2tHMDle8l/fwOVYEXhlm0QJFq13iUwpwy6kd0gaJ+JweTmSkQ5+jjlVYW68CToZF2Qe+Km7qS
 ikiDtXkF6ux7NR5t4tLr48DkuIv3sv1okJGyKmksuLgWLuSvP+nbDufMztPu+fwFG8ZpatAAAA
 A==
To: fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, Hungyu Lin <dennylin0707@gmail.com>, 
 linux-unionfs@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794456845; l=3221;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=h8S3ePG03hCpC7eOjyZ1Cd5PwA2U9TzZrinNmJROrFY=;
 b=1iC8l7OV8nYQDnwtoE2Xryl2nyxJ2hX5ImPy9Hh6ebm0wARAKJRO11b8mSbeC7uWYnYEJJMeZ
 qTn8i/hDMpOBmGbDsS+s/PVzbwXnnFTmd1MZ8bfQRqV2uoGEohEdQSf
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

overlay/077 fails on ext4 with some directory hash seeds:

    entry o100 has inconsistent d_ino (131181 != 524491)

ext4 returns the entry that did not fit in a getdents buffer first in
the next call, even if it was unlinked in between. In an impure dir
overlayfs lists that stale entry with the upper inode number. POSIX
leaves it unspecified whether readdir() returns such an entry.

Do not check d_ino of that entry.

Reported-by: Hungyu Lin <dennylin0707@gmail.com>
Closes: https://lore.kernel.org/linux-unionfs/CAGEkeHcg06kHshHQ=9U6Yrs_wm8W9H28o9bcC2Qh3fw3tANbWA@mail.gmail.com/
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
On v7.4-rc2 with ext4, overlay/077 failed on hash seeds ...88bf,
...8863 and ...886e and passes now (3 runs each). generic/257 and
generic/637 pass on ext4 and on overlay. With the stale entry mark of
commit 9011c2791e63 removed, overlay/077 still reports m100 or f100 on
ext4 (seeds ...8812, ...884a, ...88bf and a random one) and on xfs.

Changes in v2:
- New subject. v1 was "overlay/077: check a stale entry in an impure
  dir on any hash seed".
- Dropped the "-" and "=" cases and the second impure dir.
- Relaxed the d_ino check instead (Amir), but only for the first
  entry of the first call after the unlink, where ext4 returns the
  stale entry. Relaxing the first entry of every buffer hid the
  regression that 9011c2791e63 fixed on some hash seeds.
- This no longer waits for a kernel change.
---
 src/t_dir_offset2.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/src/t_dir_offset2.c b/src/t_dir_offset2.c
index 026bc8f3..a6091f7a 100644
--- a/src/t_dir_offset2.c
+++ b/src/t_dir_offset2.c
@@ -46,6 +46,7 @@ int main(int argc, char *argv[])
 	struct linux_dirent64 *d;
 	struct stat st = {};
 	int bpos, total, i;
+	int ncalls = 0;
 	off_t lret;
 	int retval = EXIT_SUCCESS;
 	const char *filename = NULL;
@@ -96,6 +97,7 @@ int main(int argc, char *argv[])
 			perror("getdents");
 			exit(EXIT_FAILURE);
 		}
+		ncalls++;
 
 		if (modify && fd2 < 0 && total == 0) {
 			printf("getdents at offset 0 returned %d bytes\n", nread);
@@ -165,7 +167,18 @@ int main(int argc, char *argv[])
 					       (long long int)d->d_off);
 				if (!strcmp(filename, d->d_name)) {
 					found = 1;
-					if (st.st_ino && d->d_ino != st.st_ino) {
+					/*
+					 * The file is unlinked after the first
+					 * call. A filesystem may still return
+					 * the entry that did not fit in that
+					 * buffer first in the second call. In
+					 * an impure dir overlayfs lists such a
+					 * stale entry with the upper inode
+					 * number, not the st_ino seen before.
+					 * Skip the check for that one entry.
+					 */
+					if (st.st_ino && d->d_ino != st.st_ino &&
+					    (exists || bpos || ncalls != 2)) {
 						fprintf(stderr, "entry %s has inconsistent d_ino (%lld != %lld)\n",
 								filename,
 								(long long int)d->d_ino,

---
base-commit: 71641219a506ac62bfa231592394265ca812670e
change-id: 20261110-ovl077-stale-next-af1a98ce7151

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


