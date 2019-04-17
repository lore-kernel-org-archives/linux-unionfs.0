From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 2/5] fscrypt: fix race allowing rename()
 and link() of ciphertext dentries
Date: Wed, 17 Apr 2019 09:53:19 -0400
Message-ID: <20190417135319.GB4686@mit.edu>
References: <20190320183913.12686-1-ebiggers@kernel.org>
 <20190320183913.12686-3-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190320183913.12686-3-ebiggers@kernel.org>
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

On Wed, Mar 20, 2019 at 11:39:10AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Close some race conditions where fscrypt allowed rename() and link() on
> ciphertext dentries that had been looked up just prior to the key being
> concurrently added.  It's better to return -ENOKEY in this case.
> 
> This avoids doing the nonsensical thing of encrypting the names a second
> time when searching for the actual on-disk dir entries.  It also
> guarantees that DCACHE_ENCRYPTED_NAME dentries are never rename()d, so
> the dcache won't have support all possible combinations of moving
> DCACHE_ENCRYPTED_NAME around during __d_move().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good, applied.

					- Ted
