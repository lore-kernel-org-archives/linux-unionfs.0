From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests PATCH v2 1/5] common/rc: improve mounted check helper
Date: Tue, 6 Feb 2018 23:21:58 +0800
Message-ID: <20180206152158.GR18267@eguan.usersys.redhat.com>
References: <20180131102759.40997-1-yi.zhang@huawei.com>
 <20180131102759.40997-2-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180131102759.40997-2-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jan 31, 2018 at 06:27:55PM +0800, zhangyi (F) wrote:
> Modify _is_mounted() to accept a dir and fstype as input, and check
> whether this dir is a specified type of mount point.
> 
> This patch also fix the problem of missing fstype check:
> 
> For example:
>   Base mounted filesystem:
>     /dev/sda2 on /boot type ext4 (rw,relatime,data=ordered)
> 
>   FSTYPE=xfs
>   mountpoint=`_is_mounted /dev/sda1`
>   echo "$mountpoint"
> 
>   Output: /boot
> 
> This patch remove the useless error message, return empty if no
> valid mount point.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/rc | 25 ++++++++++---------------
>  1 file changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 2e3a83a..3351f00 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2372,27 +2372,22 @@ _scratch_mkfs_richacl()
>  	esac
>  }
>  
> -# check that a FS on a device is mounted
> +# check that a FS on a device is mounted or a dir is a mount point

Hmm, I'm thinking about introducing a new _is_dir_mountpoint() function
for overlay use, and rename _is_mounted to _is_dev_mounted, so we don't
overload _is_mounted.

Further, I think we could take use of findmnt instead of parsing the
output from mount, which could be hard to do correctly. e.g.

# check if the given device is mounted, if so, return mount point
_is_dev_mounted()
{
	local dev=$1
	local fstype=${2:-$FSTYP}

	if [ $# -lt 1 ]; then
		echo "Usage: _is_dev_mounted <device> [fstype]" >&2
		exit 1
	fi
	findmnt -rncv -S $dev -t $fstype -o TARGET | head -1
}

And similarly

# check if the given dir is a mount point, if so, return mount point
_is_dir_mountpoint()
{
	local dir=$1
	local fstype=${2:-$FSTYP}
	...
	findmnt -rncv -T $dir -t $fstype -o TARGET | head -1
}

Note that I just slightly tested it, not sure if it'll work as expected
fully. (And please introduce _is_dir_mountpoint along with its first
usage, i.e. fold it to patch 2/5, if it works as expected.)

Thanks,
Eryu

>  # if so, return mount point
>  #
>  _is_mounted()
>  {
> -    if [ $# -ne 1 ]
> -    then
> -	echo "Usage: _is_mounted device" 1>&2
> -	exit 1
> -    fi
> +	if [ $# -lt 1 ]; then
> +		echo "Usage: _is_mounted <device|mountpoint> [fstype]" 1>&2
> +		exit 1
> +	fi
>  
> -    device=$1
> +	local name=$1
> +	local fstype=${2-$FSTYP}
>  
> -    if _mount | grep "$device " | $AWK_PROG -v pattern="type $FSTYP" '
> -        pattern        { print $3 ; exit 0 }
> -        END            { exit 1 }
> -    '
> -    then
> -        echo "_is_mounted: $device is not a mounted $FSTYP FS"
> -        exit 1
> -    fi
> +	_mount | grep "$name " | $AWK_PROG -v pattern="type $fstype" '
> +		$0 ~ pattern	{ print $3 }
> +	'
>  }
>  
>  # remount a FS to a new mode (ro or rw)
> -- 
> 2.5.0
> 
