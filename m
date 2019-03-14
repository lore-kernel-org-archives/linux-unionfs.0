From: Richard Weinberger <richard@nod.at>
Subject: [RFC] fscrypt_key_required mount option
Date: Thu, 14 Mar 2019 18:15:55 +0100
Message-ID: <20190314171559.27584-1-richard@nod.at>
References: <CAJfpegvX4ANfso-Jn1zaB+m4Q_0eK9i-+MCJ+sTH5QzD3PZFMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <CAJfpegvX4ANfso-Jn1zaB+m4Q_0eK9i-+MCJ+sTH5QzD3PZFMQ@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: linux-mtd@lists.infradead.org
Cc: tytso@mit.edu, miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, paullawrence@google.com, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org
List-Id: linux-unionfs@vger.kernel.org

This series is an RFC, it outlines how an filesystem, in this case UBIFS,
could implement a mount option to disable filesystem operations on encrypted
files where no key is present.
The desired byproduct is that in this case ->d_revalidate() is not needed
anymore and VFS folks are in less fear about the dcache implications.

Thanks,
//richard

[PATCH 1/4] fscrypt: Implement FS_CFLG_OWN_D_OPS
[PATCH 2/4] fscrypt: Export fscrypt_d_ops
[PATCH 3/4] ubifs: Simplify fscrypt_get_encryption_info() error
[PATCH 4/4] ubifs: Implement new mount option, fscrypt_key_required


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
