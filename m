From: Richard Weinberger <richard@nod.at>
Subject: Re: Regression in handling power cuts since 3a1e819b4e80 ("ovl: store
 file handle of lower inode on copy up")
Date: Sat, 27 Oct 2018 21:33:56 +0200
Message-ID: <6556017.quyC1DpDMg@blindfold>
References: <CACna6rx3YBNYKGu7T-J2J-S_3yr-oafJf3pL5TbGDFRzU6dihg@mail.gmail.com>
 <CAOQ4uxii0rZv3SVXWNN7yug_WZ-TKLL3Wo-mti0y9K66Z+-EcQ@mail.gmail.com>
 <CACna6rzvzc-_X3VDeA-nwtTW7KHaQGtbvzjVNoOFEQuHKi3PJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1960845.MarFMtrmzt"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <CACna6rzvzc-_X3VDeA-nwtTW7KHaQGtbvzjVNoOFEQuHKi3PJg@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Amir Goldstein <amir73il@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-mtd@lists.infradead.org, Russell Senior <russell@personaltelco.net>, linux-fsdevel@vger.kernel.org, OpenWrt Development List <openwrt-devel@lists.openwrt.org>
List-Id: linux-unionfs@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1960845.MarFMtrmzt
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Rafa=C5=82,

Am Montag, 22. Oktober 2018, 17:34:44 CEST schrieb Rafa=C5=82 Mi=C5=82ecki:
> Then I took a close look at ovl_copy_up_locked() and it seems above
> info isn't accurate. It seems to me that setxattr() happens between
> fsync and link. I modified my C app to follow that order (open, write,
> fsync, setxattr, link) and I can reproduce the problem now!
>=20
> Steps to reproduce the problem:
> 1) compile tmptest.c
> 2) tmptest /overlay/upper/foo.txt user.bar baz
> 3) wait 5 seconds (so ubifs writes to flash)
> 4) power cut
> 5) boot again and check content of /overlay/upper/foo.txt
> 6) in my case content appears to be 00 00 00 00

Just returned from Edinburgh and had a chance to look at the problem.
The problem is not that no write-back happens, in fact it happens just fine.
But we have a problem upon journal replay if an unlinked file (O_TMPFILE)
gets relinked in combination with xattrs.

Can you please give the attached patch a try? It is not perfect but if I=20
understand the problem correctly it should fix the issues you're facing.

Thanks,
//richard
--nextPart1960845.MarFMtrmzt
Content-Disposition: attachment; filename="replay_tmpfile_fix.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="replay_tmpfile_fix.diff"

diff --git a/fs/ubifs/replay.c b/fs/ubifs/replay.c
index 4844538eb926..82b1244e4138 100644
--- a/fs/ubifs/replay.c
+++ b/fs/ubifs/replay.c
@@ -209,6 +209,19 @@ static int trun_remove_range(struct ubifs_info *c, struct replay_entry *r)
 	return ubifs_tnc_remove_range(c, &min_key, &max_key);
 }
 
+static bool inode_comes_back(struct ubifs_info *c, struct replay_entry *rino)
+{
+	struct replay_entry *r;
+
+	list_for_each_entry(r, &c->replay_list, list) {
+		if (keys_cmp(c, &rino->key, &r->key) == 0 &&
+		    r->deletion == 0)
+			return true;
+	}
+
+	return false;
+}
+
 /**
  * apply_replay_entry - apply a replay entry to the TNC.
  * @c: UBIFS file-system description object
@@ -218,7 +231,7 @@ static int trun_remove_range(struct ubifs_info *c, struct replay_entry *r)
  */
 static int apply_replay_entry(struct ubifs_info *c, struct replay_entry *r)
 {
-	int err;
+	int err = 0;
 
 	dbg_mntk(&r->key, "LEB %d:%d len %d deletion %d sqnum %llu key ",
 		 r->lnum, r->offs, r->len, r->deletion, r->sqnum);
@@ -236,6 +249,9 @@ static int apply_replay_entry(struct ubifs_info *c, struct replay_entry *r)
 			{
 				ino_t inum = key_inum(c, &r->key);
 
+				if (inode_comes_back(c, r))
+					break;
+
 				err = ubifs_tnc_remove_ino(c, inum);
 				break;
 			}

--nextPart1960845.MarFMtrmzt
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

--nextPart1960845.MarFMtrmzt--
