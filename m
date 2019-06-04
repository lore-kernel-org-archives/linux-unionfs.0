Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/2] fanotify06: Close all file descriptors of read events
Date: Tue,  4 Jun 2019 18:10:35 +0300
Message-Id: <20190604151035.6123-2-amir73il@gmail.com>
In-Reply-To: <20190604151035.6123-1-amir73il@gmail.com>
References: <20190604151035.6123-1-amir73il@gmail.com>
To: Petr Vorel <pvorel@suse.cz>
Cc: Cyril Hrubis <chrubis@suse.cz>, Murphy Zhou <xzhou@redhat.com>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, ltp@lists.linux.it
List-ID: <linux-unionfs@vger.kernel.org>

With overlayfs test case on kernel v4.19, we get extra events.
If we do not close the event->fd file descriptros of all the events
that we read, overlayfs will fail to unmount at the end of the test
and test will retry un-mounting for a while.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../kernel/syscalls/fanotify/fanotify06.c      | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/testcases/kernel/syscalls/fanotify/fanotify06.c b/testcases/kernel/syscalls/fanotify/fanotify06.c
index e053da0e5..273c1f0c4 100644
--- a/testcases/kernel/syscalls/fanotify/fanotify06.c
+++ b/testcases/kernel/syscalls/fanotify/fanotify06.c
@@ -148,6 +148,17 @@ static void verify_event(int group, struct fanotify_event_metadata *event)
 	}
 }
 
+/* Close all file descriptors of read events */
+static void close_events_fd(struct fanotify_event_metadata *event, int buflen)
+{
+	while (buflen >= (int)FAN_EVENT_METADATA_LEN) {
+		if (event->fd != FAN_NOFD)
+			SAFE_CLOSE(event->fd);
+		buflen -= (int)FAN_EVENT_METADATA_LEN;
+		event++;
+	}
+}
+
 void test_fanotify(unsigned int n)
 {
 	int ret;
@@ -198,17 +209,16 @@ void test_fanotify(unsigned int n)
 		} else {
 			verify_event(i, event);
 		}
-		if (event->fd != FAN_NOFD)
-			SAFE_CLOSE(event->fd);
+		close_events_fd(event, ret);
 	}
+
 	for (p = 1; p < FANOTIFY_PRIORITIES; p++) {
 		for (i = 0; i < GROUPS_PER_PRIO; i++) {
 			ret = read(fd_notify[p][i], event_buf, EVENT_BUF_LEN);
 			if (ret > 0) {
 				tst_res(TFAIL, "group %d got event",
 					p*GROUPS_PER_PRIO + i);
-				if (event->fd != FAN_NOFD)
-					SAFE_CLOSE(event->fd);
+				close_events_fd((void *)event_buf, ret);
 			} else if (ret == 0) {
 				tst_brk(TBROK, "zero length "
 					"read from fanotify fd");
-- 
2.17.1
