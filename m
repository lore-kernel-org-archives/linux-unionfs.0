From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 5/5] fscrypt: fix race where ->lookup()
 marks plaintext dentry as ciphertext
Date: Wed, 17 Apr 2019 10:24:35 -0400
Message-ID: <20190417142435.GE4686@mit.edu>
References: <20190320183913.12686-1-ebiggers@kernel.org>
 <20190320183913.12686-6-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190320183913.12686-6-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, linux-mtd@lists.infradead.org, Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Mar 20, 2019 at 11:39:13AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> ->lookup() in an encrypted directory begins as follows:
> 
> 1. fscrypt_prepare_lookup():
>     a. Try to load the directory's encryption key.
>     b. If the key is unavailable, mark the dentry as a ciphertext name
>        via d_flags.
> 2. fscrypt_setup_filename():
>     a. Try to load the directory's encryption key.
>     b. If the key is available, encrypt the name (treated as a plaintext
>        name) to get the on-disk name.  Otherwise decode the name
>        (treated as a ciphertext name) to get the on-disk name.
> 
> But if the key is concurrently added, it may be found at (2a) but not at
> (1a).  In this case, the dentry will be wrongly marked as a ciphertext
> name even though it was actually treated as plaintext.
> 
> This will cause the dentry to be wrongly invalidated on the next lookup,
> potentially causing problems.  For example, if the racy ->lookup() was
> part of sys_mount(), then the new mount will be detached when anything
> tries to access it.  This is despite the mountpoint having a plaintext
> path, which should remain valid now that the key was added.
> 
> Of course, this is only possible if there's a userspace race.  Still,
> the additional kernel-side race is confusing and unexpected.
> 
> Close the kernel-side race by changing fscrypt_prepare_lookup() to also
> set the on-disk filename (step 2b), consistent with the d_flags update.
> 
> Fixes: 28b4c263961c ("ext4 crypto: revalidate dentry after adding or removing the key")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good, applied.

					- Ted
