From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/4] ubifs: Implement new mount option,
 fscrypt_key_required
Date: Thu, 14 Mar 2019 16:15:11 -0700
Message-ID: <1552605311.2571.6.camel@HansenPartnership.com>
References: <CAJfpegvX4ANfso-Jn1zaB+m4Q_0eK9i-+MCJ+sTH5QzD3PZFMQ@mail.gmail.com>
 <20190314171559.27584-1-richard@nod.at>
 <20190314171559.27584-5-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20190314171559.27584-5-richard@nod.at>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org
Cc: tytso@mit.edu, miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, paullawrence@google.com, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, 2019-03-14 at 18:15 +0100, Richard Weinberger wrote:
> Usually fscrypt allows limited access to encrypted files even
> if no key is available.
> Encrypted filenames are shown and based on this names users
> can unlink and move files.

Shouldn't they be able to read/write and create as well (all with the
ciphertext name and contents, of course) ... otherwise how does backup
of encrypted files by admin without the key ever work?

James


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
