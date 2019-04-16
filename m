From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 1/5] fscrypt: clean up and improve dentry revalidation
Date: Tue, 16 Apr 2019 19:08:40 -0400
Message-ID: <20190416230840.GB14623@mit.edu>
References: <20190320183913.12686-1-ebiggers@kernel.org>
 <20190320183913.12686-2-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190320183913.12686-2-ebiggers@kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: Gao Xiang <gaoxiang25@huawei.com>, linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, linux-mtd@lists.infradead.org, Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 20, 2019 at 11:39:09AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Make various improvements to fscrypt dentry revalidation:
> 
> - Don't try to handle the case where the per-directory key is removed,
>   as this can't happen without the inode (and dentries) being evicted.
> 
> - Flag ciphertext dentries rather than plaintext dentries, since it's
>   ciphertext dentries that need the special handling.
> 
> - Avoid doing unnecessary work for non-ciphertext dentries.
> 
> - When revalidating ciphertext dentries, try to set up the directory's
>   i_crypt_info to make sure the key is really still absent, rather than
>   invalidating all negative dentries as the previous code did.  An old
>   comment suggested we can't do this for locking reasons, but AFAICT
>   this comment was outdated and it actually works fine.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good, applied.

					- Ted

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
