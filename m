From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 0/5] fscrypt: d_revalidate fixes and
 cleanups
Date: Mon, 1 Apr 2019 10:11:21 -0700
Message-ID: <20190401171119.GC131675@gmail.com>
References: <20190320183913.12686-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190320183913.12686-1-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org, Richard Weinberger <richard@nod.at>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 20, 2019 at 11:39:08AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This patch series improves dentry revalidation in fscrypt.
> 
> To recap, fscrypt (aka ext4/f2fs/ubifs encryption) encrypts both file
> contents and file names in individual directory trees.  A single
> filesystem can contain many encrypted directory trees using many
> different encryption keys.  Major users of fscrypt require the ability
> to delete encrypted files when their encryption key is unavailable, e.g.
> when the system needs to delete a removed user's home directory or free
> up space from a logged-out user's cache directory.
> 
> Therefore fscrypt allows listing, looking up, and deleting files in
> encrypted directories via encoded ciphertext names, but only before the
> key is added.  After the key is added, the ciphertext names are
> invalidated via ->d_revalidate() and plaintext names are shown instead.
> 
> fscrypt isn't a stacked filesystem, and it's explicitly for storage
> encryption, not OS-level access control.  Thus, whether each directory
> inode has its key or not is a global state, not per-process.  Also, the
> inode keeps its key until it's evicted from the inode cache.  So,
> plaintext names shouldn't ever get invalidated by ->d_revalidate().
> 
> This patch series makes the following improvements:
> 
> - Only assign ->d_revalidate() to ciphertext filenames, thus allowing
>   overlayfs to use an fscrypt-encrypted upperdir in some cases.
>   (Previous discussion: https://lkml.org/lkml/2019/3/13/255)
> 
> - Fix cases where plaintext filenames would wrongly be invalidated,
>   including a real-world bug recently reported on Chromium OS.
> 
> - Fix cases where ciphertext filenames would wrongly not be invalidated.
> 
> - Allow rcu-walk lookups in encrypted directories with the key, which
>   improves performance.
>   (Previous attempt: https://patchwork.kernel.org/patch/10594133/)
> 
> - Fix cases where rename() and link() could succeed on ciphertext names.
> 
> Changed since v1:
> 
> - Fixed comment in fscrypt_d_revalidate() to explain that dget_parent()
>   is actually still required.
> 
> - Moved clearing DCACHE_ENCRYPTED_NAME into fscrypt.h, to avoid an extra
>   #ifdef and cluttering up dcache.c.
> 
> Eric Biggers (5):
>   fscrypt: clean up and improve dentry revalidation
>   fscrypt: fix race allowing rename() and link() of ciphertext dentries
>   fs, fscrypt: clear DCACHE_ENCRYPTED_NAME when unaliasing directory
>   fscrypt: only set dentry_operations on ciphertext dentries
>   fscrypt: fix race where ->lookup() marks plaintext dentry as
>     ciphertext
> 
>  fs/crypto/crypto.c      | 58 ++++++++++++++++---------------
>  fs/crypto/fname.c       |  1 +
>  fs/crypto/hooks.c       | 28 ++++++++++-----
>  fs/dcache.c             |  2 ++
>  fs/ext4/ext4.h          | 62 +++++++++++++++++++++++++--------
>  fs/ext4/namei.c         | 76 ++++++++++++++++++++++++++++-------------
>  fs/f2fs/namei.c         | 17 +++++----
>  fs/ubifs/dir.c          |  8 ++---
>  include/linux/dcache.h  |  2 +-
>  include/linux/fscrypt.h | 61 +++++++++++++++++++++++----------
>  10 files changed, 208 insertions(+), 107 deletions(-)
> 
> -- 
> 2.21.0.225.g810b269d1ac-goog
> 

Any more comments on these patches?  I'd like to apply them to the fscrypt tree
for 5.2.  Richard, can you check whether these solve your overlayfs use case?
Also, patch 5 could use Acks from ext4, f2fs, and ubifs people.

- Eric
